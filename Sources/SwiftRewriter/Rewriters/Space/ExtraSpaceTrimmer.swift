import SwiftSyntax

/// Trim 2 or more extra spaces into 1 space.
///
/// - Warning:
/// This rewriter may be a problem
/// if you manually align your code in multiple `=` assignments.
/// Smart alignment rewriter is probably our future.
open class ExtraSpaceTrimmer: SyntaxRewriter
{
    private var _skipsNextLeadingTriva = false

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        var token2 = token

        if !token.leadingTrivia.hasNewline && !self._skipsNextLeadingTriva
        {
            let lastSpaces = token.leadingTrivia.pieces.last?.isSpace == true
                ? [TriviaPiece.spaces(1)]
                : []
            token2 = token2.with(.leadingTrivia, replacingLastSpaces: lastSpaces)
        }

        self._skipsNextLeadingTriva = false

        if token.nextToken?.leadingTrivia.first?.isComment == true {
            // Skip handling trailingTrivia and next leadingTrivia.
            self._skipsNextLeadingTriva = true
        }
        else if !token.trailingTrivia.hasNewline {
            let firstSpaces = token.trailingTrivia.pieces.first?.isSpace == true
                ? [TriviaPiece.spaces(1)]
                : []
            token2 = token2.with(.trailingTrivia, replacingFirstSpaces: firstSpaces)
        }

        return super.visit(token2)
    }
}
