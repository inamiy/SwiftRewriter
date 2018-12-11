import SwiftSyntax

/// Insert or remove a space before `:`.
/// - Note: For handling `TernaryExpr`, use `TernaryExprSpacer`.
open class ColonSpacer: SyntaxRewriter, HasRewriterExamples
{
    private let _spaceBefore: Bool
    private let _spaceAfter: Bool

    private let _spaceHandler: TokenHandler

    var rewriterExamples: [String: String]
    {
        return _rewriterExamples
            .merging(_rewriterExamplesNoChange, uniquingKeysWith: { $1 })
    }

    private var _rewriterExamples: [String: String]
    {
        switch (self._spaceBefore, self._spaceAfter) {
        case (true, true):
            return [
                "func(x:Int) {}": "func(x : Int) {}",
                "[1:x, 2:y]": "[1 : x, 2 : y]",
                "[Int␣/**/: String]": "[Int␣/**/: String]" // ignore handling if comment exists
            ]
        case (false, true):
            return [
                "func(x :Int) {}": "func(x: Int) {}",
                "[1 :x, 2 :y]": "[1: x, 2: y]",
                "[Int␣/**/: String]": "[Int␣/**/: String]"
            ]
        case (true, false):
            return [
                "func(x: Int) {}": "func(x :Int) {}",
                "[1: x, 2: y]": "[1 :x, 2 :y]",
                "[Int␣/**/: String]": "[Int␣/**/:String]"
            ]
        case (false, false):
            return [
                "func(x : Int) {}": "func(x:Int) {}",
                "[1 : x, 2 : y]": "[1:x, 2:y]",
                "[Int␣/**/: String]": "[Int␣/**/:String]"
            ]
        }
    }

    /// - Note: `if #available(..., *)` (UnknownStmtSyntax bug) will not be handled.
    private var _rewriterExamplesNoChange: [String: String]
    {
        let noChanges = [
            "[:]",
            "[ : ]",
            "[: ]",
            "[ :]",
            "arr.map(State.init(rawValue:))"
            ]

        return [String: String](noChanges.map { ($0, $0) }, uniquingKeysWith: { $1 })
    }

    public init(spaceBefore: Bool = false, spaceAfter: Bool = true)
    {
        self._spaceBefore = spaceBefore
        self._spaceAfter = spaceAfter

        func check(_ token: TokenSyntax?) -> Bool
        {
            return token?.tokenKind == .colon
                && !(token?.parent is DeclNameArgumentSyntax)   // ignore e.g. `Value.init(rawValue:)`
                && token?.ancestor(where: { $0 as? AttributeSyntax }) == nil
        }

        let spaceBeforeHandler = TokenHandler.handleTrailingSpacesBefore(
            shouldInsert: spaceBefore,
            // NOTE: ignore `let dict = [␣:]`
            preprocess: .check { token in
                guard !token.tokenKind.isOpeningSymbol else { return false }

                guard let nextToken = token.nextToken, check(token.nextToken) else { return false }

                // Check `nextToken`'s leading comment, and if exists, skip space adjustment,
                // e.g. `[Int␣/**/: String]`.
                return !nextToken.leadingTrivia.contains(where: { $0.isComment })
            }
        )

        let spaceAfterHandler = TokenHandler.handleTrailingSpacesAfter(
            shouldInsert: spaceAfter,
            // NOTE: ignore `let dict = [:␣]`
            preprocess: .check { check($0) && $0.nextToken?.tokenKind.isClosingSymbol == false }
        )

        self._spaceHandler = spaceBeforeHandler <+> spaceAfterHandler
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        return super.visit(self._spaceHandler.run(token) ?? token)
    }
}
