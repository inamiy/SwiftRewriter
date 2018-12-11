import SwiftSyntax

/// Insert or remove a space before `?` and `:`.
/// - Warning: Conflicts with `ColonSpacer`, so call `ColonSpacer` then `TernaryExprSpacer`.
open class TernaryExprSpacer: SyntaxRewriter, HasRewriterExamples
{
    private let _spaceHandler: TokenHandler

    var rewriterExamples: [String: String]
    {
        return [
            "flag ?true:false": "flag ? true : false"
        ]
    }

    public override init()
    {
        func check(_ token: TokenSyntax?) -> Bool
        {
            let tokenKind = token?.tokenKind
            return (tokenKind == .colon || tokenKind == .infixQuestionMark)
                && token?.parent is TernaryExprSyntax
        }

        let spaceBeforeHandler = TokenHandler.handleTrailingSpacesBefore(
            shouldInsert: true,
            preprocess: .check { check($0.nextToken) }
        )

        let spaceAfterHandler = TokenHandler.handleTrailingSpacesAfter(
            shouldInsert: true,
            preprocess: .check(check)
        )

        self._spaceHandler = spaceBeforeHandler <+> spaceAfterHandler
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        return super.visit(self._spaceHandler.run(token) ?? token)
    }
}
