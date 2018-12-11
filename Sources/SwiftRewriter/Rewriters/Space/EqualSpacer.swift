import SwiftSyntax

/// Insert or remove a space before `=` assignment.
open class EqualSpacer: SyntaxRewriter, HasRewriterExamples
{
    private let _spacesAround: Bool

    private let _spaceHandler: TokenHandler

    private var _unknownStmtCount = 0
    private var _attributeCount = 0

    var rewriterExamples: [String: String]
    {
        switch self._spacesAround {
        case true:
            return [
                "let x=1+2": "let x = 1+2",
                "let `x`=1+2": "let `x` = 1+2",
            ]
        case false:
            return [
                "let x = 1+2": "let x=1+2",
                "let `x` = 1+2": "let `x`=1+2",
            ]
        }
    }

    public init(spacesAround: Bool = true)
    {
        self._spacesAround = spacesAround

        func check(_ token: TokenSyntax?) -> Bool
        {
            return token?.tokenKind == .equal
        }

        let spaceBeforeHandler = TokenHandler.handleTrailingSpacesBefore(
            shouldInsert: spacesAround,
            preprocess: .check { check($0.nextToken) }
        )

        let spaceAfterHandler = TokenHandler.handleTrailingSpacesAfter(
            shouldInsert: spacesAround,
            preprocess: .check(check)
        )

        self._spaceHandler = spaceBeforeHandler <+> spaceAfterHandler
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        return super.visit(self._spaceHandler.run(token) ?? token)
    }
}
