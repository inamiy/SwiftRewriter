import SwiftSyntax

/// Remove trailing spaces.
open class TrailingSpaceTrimmer: SyntaxRewriter
{
    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        guard let nextToken = token.nextToken else {
            return super.visit(token)
        }

        let isTrailingToken = nextToken.leadingTrivia.first?.isNewline == true
            || (nextToken.tokenKind == .eof && nextToken.leadingTrivia.allSatisfy { $0.isSpace || $0.isNewline })

        var token2 = token

        if isTrailingToken {
            token2 = token.with(.trailingTrivia, replacingFirstSpaces: 0)
        }

        return super.visit(token2)
    }
}
