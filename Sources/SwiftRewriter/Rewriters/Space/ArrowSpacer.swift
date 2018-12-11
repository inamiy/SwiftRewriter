import SwiftSyntax

/// Insert or remove a space before `->`.
open class ArrowSpacer: SyntaxRewriter, HasRewriterExamples
{
    private let _spaceBefore: Bool
    private let _spaceAfter: Bool

    private let _spaceHandler: TokenHandler

    var rewriterExamples: [String: String]
    {
        switch (self._spaceBefore, self._spaceAfter) {
        case (true, true):
            return [
                "func(x: Int)->Int {}": "func(x: Int) -> Int {}",
                "run { x->Int in }": "run { x -> Int in }"
            ]
        case (false, true):
            return [
                "func(x: Int) ->Int {}": "func(x: Int)-> Int {}",
                "run { x ->Int in }": "run { x-> Int in }"
            ]
        case (true, false):
            return [
                "func(x: Int)-> Int {}": "func(x: Int) ->Int {}",
                "run { x-> Int in }": "run { x ->Int in }"
            ]
        case (false, false):
            return [
                "func(x: Int) -> Int {}": "func(x: Int)->Int {}",
                "run { x -> Int in }": "run { x->Int in }"
            ]
        }
    }

    public init(spaceBefore: Bool = true, spaceAfter: Bool = true)
    {
        self._spaceBefore = spaceBefore
        self._spaceAfter = spaceAfter

        func check(_ token: TokenSyntax?) -> Bool
        {
            return token?.tokenKind == .arrow
        }

        let spaceBeforeHandler = TokenHandler.handleTrailingSpacesBefore(
            shouldInsert: spaceBefore,
            preprocess: .check { check($0.nextToken) }
        )

        let spaceAfterHandler = TokenHandler.handleTrailingSpacesAfter(
            shouldInsert: spaceAfter,
            preprocess: .check(check)
        )

        self._spaceHandler = spaceBeforeHandler <+> spaceAfterHandler
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        return super.visit(self._spaceHandler.run(token) ?? token)
    }
}
