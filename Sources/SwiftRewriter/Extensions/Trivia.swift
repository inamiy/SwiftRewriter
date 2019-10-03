import SwiftSyntax

// MARK: - Trivia

extension Trivia: CustomStringConvertible
{
    var pieces: [TriviaPiece]
    {
        return Array(self)
    }

    public var description: String
    {
        return self.pieces.reduce(into: "", { $0 += "\($1)" })
    }
}

extension Trivia
{
    func inserting(_ piece: TriviaPiece, at index: Int) -> Trivia
    {
        var pieces = self.pieces
        pieces.insert(piece, at: index)
        return Trivia(pieces: pieces)
    }
}

extension Trivia
{
    var hasEmptyNewline: Bool
    {
        for i in self.indices.dropLast() {
            // NOTE: Empty newline = 2 consecutive pieces are both newlines
            if self[i].isNewline && self[i + 1].isNewline {
                return true
            }
        }
        return false
    }

    var isNewlineAtFirstExceptSpaces: Bool
    {
        // NOTE: Trim first `.spaces` before evaluation.
        return self.lazy.first(where: { !$0.isSpace })?.isNewline == true
    }

    var isNewlineAtLastExceptSpaces: Bool
    {
        // NOTE: Trim last `.spaces` before evaluation.
        return self.lazy.reversed().first(where: { !$0.isSpace })?.isNewline == true
    }

    var hasNewline: Bool
    {
        for piece in self where piece.isNewline {
            return true
        }
        return false
    }

    var numberOfNewlines: Int
    {
        return self.reduce(into: 0) { acc, piece in
            acc += piece.numberOfNewlines
        }
    }
}

// MARK: - TriviaPiece

extension TriviaPiece: CustomStringConvertible
{
    public var description: String
    {
        switch self {
        case let .spaces(x):
            return ".spaces(\(x))"
        case let .tabs(x):
            return ".tabs(\(x))"
        case let .verticalTabs(x):
            return ".verticalTabs(\(x))"
        case let .formfeeds(x):
            return ".formfeeds(\(x))"
        case let .newlines(x):
            return ".newlines(\(x))"
        case let .carriageReturns(x):
            return ".carriageReturns(\(x))"
        case let .carriageReturnLineFeeds(x):
            return ".carriageReturnLineFeeds(\(x))"
        case let .backticks(x):
            return ".backticks(\(x))"
        case let .lineComment(x):
            return ".lineComment(\(x))"
        case let .blockComment(x):
            return ".blockComment(\(x))"
        case let .docLineComment(x):
            return ".docLineComment(\(x))"
        case let .docBlockComment(x):
            return ".docBlockComment(\(x))"
        case let .garbageText(x):
            return ".garbageText(\(x))"
        }
    }
}

extension TriviaPiece
{
    /// True if `.spaces` or `.tabs`.
    var isSpace: Bool
    {
        switch self {
        case .spaces,
             .tabs:
            return true
        default:
            return false
        }
    }

    /// True if `.lineComment` or `.blockComment` or `.docLineComment` or `.docBlockComment`.
    var isComment: Bool
    {
        switch self {
        case .lineComment,
             .blockComment,
             .docLineComment,
             .docBlockComment:
            return true
        default:
            return false
        }
    }

    var commentString: String?
    {
        switch self {
        case let .lineComment(s),
             let .blockComment(s),
             let .docLineComment(s),
             let .docBlockComment(s):
            return s
        default:
            return nil
        }
    }

    /// True if `.lineComment`.
    var isLineComment: Bool
    {
        switch self {
        case .lineComment:
            return true
        default:
            return false
        }
    }

    /// True if `docLineComment` or `.docBlockComment`.
    var isDocComment: Bool
    {
        switch self {
        case .docLineComment,
             .docBlockComment:
            return true
        default:
            return false
        }
    }

    /// True if `.newlines` or `.carriageReturnLineFeeds`.
    var isNewline: Bool
    {
        switch self {
        case .newlines,
             .carriageReturnLineFeeds:
            return true
        default:
            return false
        }
    }

    var numberOfNewlines: Int
    {
        switch self {
        case let .newlines(n),
             let .carriageReturnLineFeeds(n):
            return n
        default:
            return 0
        }
    }

    var isBacktick: Bool
    {
        switch self {
        case .backticks:
            return true
        default:
            return false
        }
    }
}
