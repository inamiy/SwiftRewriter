import SwiftSyntax

/// Insert a space between `if`, `guard`, `for`, `while`, `switch`, and `(`.
open class LeftParenSpacer: SyntaxRewriter, HasRewriterExamples
{
    private let _spaceBefore: Bool
    private let _spaceHandler: TokenHandler

    /// - Todo: Use `Set<TokenKind>` when `TokenKind` supports `Hashable`.
    private static let _stmtTokenKinds: [TokenKind] = [
        .ifKeyword, .guardKeyword, .forKeyword, .whileKeyword, .switchKeyword
    ]

    var rewriterExamples: [String: String]
    {
        switch self._spaceBefore {
        case true:
            return [
                "if(flag) {}": "if (flag) {}",
                "guard(flag) else { return }": "guard (flag) else { return }",
                "for(k,v) in dict {}": "for (k,v) in dict {}",
                "while(flag) {}": "while (flag) {}",
                "switch(flag) { case .a: break }": "switch (flag) { case .a: break }"
            ]
        case false:
            return [
                "if (flag) {}": "if(flag) {}",
                "guard (flag) else { return }": "guard(flag) else { return }",
                "for (k,v) in dict {}": "for(k,v) in dict {}",
                "while (flag) {}": "while(flag) {}",
                "switch (flag) { case .a: break }": "switch(flag) { case .a: break }"
            ]
        }
    }

    var rewriterNoChangeExamples: [String]
    {
        return [
            "func foo() {}",
            "func foo () {}",
            "init() {}",
            "init () {}",
            ]
    }

    public init(spaceBefore: Bool = true)
    {
        self._spaceBefore = spaceBefore

        func check(_ token: TokenSyntax) -> Bool
        {
            return LeftParenSpacer._stmtTokenKinds.contains(token.tokenKind)
                && token.nextToken?.tokenKind == .leftParen
        }

        self._spaceHandler = TokenHandler.handleTrailingSpacesBefore(
            shouldInsert: spaceBefore,
            preprocess: .check(check)
        )
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        return super.visit(self._spaceHandler.run(token) ?? token)
    }
}
