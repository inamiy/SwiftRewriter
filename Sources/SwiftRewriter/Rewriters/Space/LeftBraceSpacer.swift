import SwiftSyntax

/// Insert or remove a space before `{`.
open class LeftBraceSpacer: SyntaxRewriter, HasRewriterExamples
{
    private let _spaceBefore: Bool
    private let _spaceHandler: TokenHandler

    var rewriterExamples: [String: String]
    {
        switch self._spaceBefore {
        case true:
            return [
                "if flag{}" : "if flag {}",
                "if (flag){}": "if (flag) {}",
                "x.map{ $0 }": "x.map { $0 }",
                "x.map({ $0 })": "x.map({ $0 })"
            ]
        case false:
            return [
                "if flag {}" : "if flag{}",
                "if (flag) {}": "if (flag){}",
                "x.map({ $0 })": "x.map({ $0 })"
            ]
        }
    }

    public init(spaceBefore: Bool = false)
    {
        self._spaceBefore = spaceBefore

        func check(_ token: TokenSyntax) -> Bool
        {
            guard token.nextToken?.tokenKind == .leftBrace else { return false }

            if spaceBefore {
                return token.tokenKind != .leftParen // NOTE: ignore `.map(␣{ $0 })`
            }
            else {
                return true
            }
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
