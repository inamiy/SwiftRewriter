import SwiftSyntax

/// Insert or remove a space before binary operator, e.g. `+`.
open class BinaryOperatorSpacer: SyntaxRewriter, HasRewriterExamples
{
    /// Flag for adding before & after spaces.
    ///
    /// - Note:
    /// Separating into `spaceBefore` & `spaceAfter` is not possible
    /// since changed code may be treated as "prefix" or "postfix" operators.
    ///
    private let _spacesAround: Bool

    private let _spaceHandler: TokenHandler

    private var _unknownStmtCount = 0
    private var _attributeCount = 0

    var rewriterExamples: [String: String]
    {
        return _rewriterExamples
            .merging(_rewriterExamplesNoChange, uniquingKeysWith: { $1 })
    }

    private var _rewriterExamples: [String: String]
    {
        switch self._spacesAround {
        case true:
            return [
                "1+2": "1 + 2",
                "array.reduce(0,+)": "array.reduce(0, +)",

                // NOTE: Won't handle spaces between binary operator and closing sybmol.
                "array.reduce(0,+ )": "array.reduce(0, + )"
            ]
        case false:
            return [
                "1 + 2": "1+2",
                "array.reduce(0, +)": "array.reduce(0,+)",

                // NOTE: Won't handle spaces between binary operator and closing sybmol.
                "array.reduce(0, + )": "array.reduce(0,+ )"
            ]
        }
    }

    private var _rewriterExamplesNoChange: [String: String]
    {
        let noChanges = [
            "reduce(+)", "reduce(+ )", "reduce( +)", "reduce( + )",
            "User.table[*]", "User.table[* ]", "User.table[ *]", "User.table[ * ]", // e.g. SQLite.swift

            // UnknownStmtSyntax bug in SwiftSyntax
            "if #available(iOS 11.0, *) {}",
            "if #available(iOS 11.0, * ) {}",
            "if #available(iOS 11.0,*) {}",

            // UnknownDeclSyntax bug in SwiftSyntax
            "@available(*, deprecated, message: \"...\")",
            "@available( * , deprecated, message: \"...\")"
            ]

        return [String: String](noChanges.map { ($0, $0) }, uniquingKeysWith: { $1 })
    }

    public init(spacesAround: Bool = true)
    {
        self._spacesAround = spacesAround

        func check(_ token: TokenSyntax?) -> Bool
        {
            guard let tokenKind = token?.tokenKind else {
                return false
            }

            return tokenKind.isBinaryOperator
        }

        let spaceBeforeHandler = TokenHandler.handleTrailingSpacesBefore(
            shouldInsert: spacesAround,
            // NOTE: ignore `reduce(␣+)`
            preprocess: .check { !$0.tokenKind.isOpeningSymbol && check($0.nextToken) }
        )

        let spaceAfterHandler = TokenHandler.handleTrailingSpacesAfter(
            shouldInsert: spacesAround,
            // NOTE: ignore `reduce(+␣)`
            preprocess: .check { check($0) && $0.nextToken?.tokenKind.isClosingSymbol == false }
        )

        self._spaceHandler = spaceBeforeHandler <+> spaceAfterHandler
    }

    // Workaround for `if #available(..., *)` (UnknownStmtSyntax bug).
    open override func visit(_ syntax: UnknownStmtSyntax) -> StmtSyntax
    {
        self._unknownStmtCount += 1
        defer { self._unknownStmtCount -= 1 }

        return super.visit(syntax)
    }

    // Ignore `*` treated as binaryOperator in `@available(*, ...)`.
    open override func visit(_ syntax: AttributeSyntax) -> Syntax
    {
        self._attributeCount += 1
        defer { self._attributeCount -= 1 }

        return super.visit(syntax)
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        guard self._unknownStmtCount == 0
            && self._attributeCount == 0 else
        {
            return super.visit(token)
        }

        return super.visit(self._spaceHandler.run(token) ?? token)
    }
}
