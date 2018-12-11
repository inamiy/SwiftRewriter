import SwiftSyntax

/// Visit first token & rewrite.
final class FirstTokenRewriter: SyntaxRewriter
{
    let rewrite: (TokenSyntax) -> TokenSyntax

    private var _isFirstToken = true

    init(rewrite: @escaping (TokenSyntax) -> TokenSyntax)
    {
        self.rewrite = rewrite
    }

    init(tokenHandler: TokenHandler)
    {
        self.rewrite = { tokenHandler.run($0) ?? $0 }
    }

    override func visit(_ token: TokenSyntax) -> Syntax
    {
        guard self._isFirstToken else {
            return super.visit(token)
        }

        self._isFirstToken = false

        let token2 = self.rewrite(token)

        return super.visit(token2)
    }
}
