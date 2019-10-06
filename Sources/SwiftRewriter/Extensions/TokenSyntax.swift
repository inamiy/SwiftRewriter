import SwiftSyntax
import FunOptics

extension TokenSyntax
{
    /// Update `withLeadingTrivia` by inserting indent before newline.
    /// - SeeAlso: `IndentStrategy`
    func withIndent(strategy: IndentStrategy) -> TokenSyntax
    {
        let isFirstToken = self.containsFirstToken

        // Run only when `isFirstToken` or multiline leading trivia.
        guard isFirstToken || self.leadingTrivia.hasNewline else {
            return self
        }

        let pieces: [TriviaPiece] = { pieces in

            let endIndex = pieces.endIndex

            var pieces2 = [TriviaPiece]()
            var skipsHeadSpacesAfterNewline = isFirstToken
            var index = pieces.startIndex

            // Append `TriviaPiece`s except spaces right after newline
            // that will be replaced by `indent`.
            while index < endIndex {
                let piece = pieces[index]

                if piece.isNewline {
                    pieces2.append(piece)

                    switch strategy {
                    case let .useIndent(indent, skipsCommentedLine, adjustsLeadingTriviaComment):

                        /// Adjusted indent for closing symbol's leadingTrivia comment.
                        let adjustedIndent = adjustsLeadingTriviaComment
                            ? indent.incrementLevel()
                            : indent

                        let nextIndex = index.advanced(by: 1)

                        /// Check next `pieces` until `.newline` to see if line is commented-out by Xcode's "Cmd + /".
                        var isCommentedOutLine: Bool
                        {
                            guard nextIndex < endIndex,
                                let commentString = pieces[nextIndex].commentString else
                            {
                                return false
                            }

                            if let nextNewlineIndex = pieces[nextIndex...].firstIndex(where: { $0.isNewline }) {
                                if pieces[nextIndex..<nextNewlineIndex].allSatisfy({ $0.isComment || $0.isSpace }) {
                                    let endIndex2 = commentString.endIndex
                                    var i = commentString.startIndex
                                    commentString.formIndex(after: &i)

                                    if i < endIndex2 && commentString[...i] == "//" {
                                        commentString.formIndex(after: &i)

                                        if i < endIndex2 && (commentString[i] == " " || commentString[i] == "\t") {
                                            commentString.formIndex(after: &i)
                                            if i < endIndex2 && (commentString[i] == " " || commentString[i] == "\t") {
                                                // e.g. `//␣␣foo`, which is probably be generated by Xcode
                                                return true
                                            }
                                        }
                                        else {
                                            // e.g. `//foo`, which is probably be generated by Xcode
                                            return true
                                        }
                                    }

                                    // e.g. `//␣foo` will reach here, which is not Xcode-generated comment.
                                    return false
                                }
                            }

                            return false
                        }

                        if adjustedIndent.level > 0 && !(skipsCommentedLine && isCommentedOutLine) {
                            if adjustsLeadingTriviaComment {
                                let isLastNewline = pieces[nextIndex...].allSatisfy { !$0.isNewline }

                                // NOTE: If last newline, indent is for closing symbol, so no need to adjust.
                                let adjustedIndentPiece = isLastNewline
                                    ? indent.triviaPiece
                                    : adjustedIndent.triviaPiece

                                pieces2.append(adjustedIndentPiece)
                            }
                            else {
                                pieces2.append(indent.triviaPiece)
                            }
                        }

                    case .forcedSpaces(let spaces):
                        if spaces > 0 {
                            pieces2.append(.spaces(spaces))
                        }
                    }

                    skipsHeadSpacesAfterNewline = true
                }
                else if piece.isSpace && skipsHeadSpacesAfterNewline {
                    // Skip appending.
                }
                else {
                    skipsHeadSpacesAfterNewline = false
                    pieces2.append(piece)
                }

                index = pieces.index(after: index)
            }

            return pieces2

        }(self.leadingTrivia.pieces)

        let token2 = self.withLeadingTrivia(Trivia(pieces: pieces))
        return token2
    }

    /// Replace `leadingTrivia` / `trailingTrivia`'s last spaces.
    func with(
        _ lens: Lens<TokenSyntax, [TriviaPiece]>,
        replacingLastSpaces lastPieces: [TriviaPiece]
        ) -> TokenSyntax
    {
        var pieces = lens.get(self)

        if !pieces.isEmpty {
            if let lastIndex = pieces.lastIndex(where: { !$0.isSpace }) {
                let removalCount = pieces.distance(from: lastIndex.advanced(by: 1),to: pieces.endIndex)
                pieces.removeLast(removalCount)
            }
            else {
                pieces.removeAll()
            }
        }

        pieces.append(contentsOf: lastPieces)

        var token2 = self
        token2 = lens.set(self, pieces)
        return token2
    }

    /// Replace `leadingTrivia` / `trailingTrivia`'s first spaces.
    func with(
        _ lens: Lens<TokenSyntax, [TriviaPiece]>,
        replacingFirstSpaces firstPieces: [TriviaPiece]
        ) -> TokenSyntax
    {
        var pieces = lens.get(self)

        if !pieces.isEmpty {
            let firstIndex = pieces.firstIndex(where: { !$0.isSpace }) ?? pieces.endIndex
            let removalCount = pieces.distance(from: pieces.startIndex, to: firstIndex)
            pieces.removeFirst(removalCount)
        }

        pieces.insert(contentsOf: firstPieces, at: 0)

        var token2 = self
        token2 = lens.set(self, pieces)
        return token2
    }

    /// Trim `leadingTrivia`'s first empty (space-only) lines except indent.
    func withoutLeadingTriviaFirstEmptyLines(replacingTo triviaPieces: [TriviaPiece] = []) -> TokenSyntax
    {
        guard self.leadingTrivia.hasNewline else {
            return self
        }

        let pieces: [TriviaPiece] = { pieces in
            var pieces2: [TriviaPiece] = []
            var startIndex = pieces.startIndex

            while startIndex < pieces.endIndex {
                let firstNewlineIndex = pieces[startIndex...].firstIndex(where: { $0.isNewline })

                if let firstNewlineIndex = firstNewlineIndex {
                    let firstPieces = pieces[startIndex...firstNewlineIndex]
                    if firstPieces.allSatisfy({ $0.isSpace || $0.isNewline }) {
                        // Skip append.
                    }
                    else {
                        pieces2.append(contentsOf: firstPieces)
                    }
                    startIndex = firstNewlineIndex.advanced(by: 1)
                }
                else {
                    // Append last line's triviaPieces as indent.
                    pieces2.append(contentsOf: pieces[startIndex..<pieces.endIndex])
                    break
                }
            }

            pieces2.insert(contentsOf: triviaPieces, at: 0)

            return pieces2

        }(self.leadingTrivia.pieces)

        var token2 = self
        token2 = self.withLeadingTrivia(.init(pieces: pieces))
        return token2
    }
}

// MARK: - TokenKind

extension TokenKind
{
    var isBinaryOperator: Bool
    {
        switch self {
        case .spacedBinaryOperator,
             .unspacedBinaryOperator:
            return true
        default:
            return false
        }
    }

    var isOpeningSymbol: Bool
    {
        switch self {
        case .leftAngle,
             .leftBrace,
             .leftParen,
             .leftSquareBracket:
            return true

        default:
            return false
        }
    }

    var isClosingSymbol: Bool
    {
        switch self {
        case .rightAngle,
             .rightBrace,
             .rightParen,
             .rightSquareBracket:
            return true

        case .poundEndifKeyword:    // explicit
            return false

        default:
            return false
        }
    }
}
