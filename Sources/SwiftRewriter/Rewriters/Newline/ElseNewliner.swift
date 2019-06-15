import SwiftSyntax

/// Insert or remove a newline between `if-else` and `do-catch`.
/// - Warning: `guard-else` is not supported yet.
/// - Note: Ignores statement that contains comments in between.
open class ElseNewliner: SyntaxRewriter
{
    private typealias _TokensHandler = OptionalKleisli<(leadingToken: TokenSyntax?, currentToken: TokenSyntax), TokenSyntax>

    private lazy var _newlineHandler: _TokensHandler = {
        if self.newline {
            return _TokensHandler { leadingToken, token in
                guard !token.leadingTrivia.hasNewline
                    && token.leadingTrivia.allSatisfy({ !$0.isComment }) else
                {
                    return nil
                }

                let column = leadingToken?.startLocation(converter: .init(tree: self.sourceFile)).column ?? 1
                let indentSpaces = column - 1
                return token.withLeadingTrivia(.newlines(1) + .spaces(indentSpaces))
            }
        }
        else {
            return _TokensHandler { leadingToken, token in
                guard token.leadingTrivia.hasNewline
                    && token.leadingTrivia.allSatisfy({ !$0.isComment }) else {
                        return nil
                }

                return token.withLeadingTrivia(.spaces(1))
            }
        }
    }()

    private let newline: Bool

    private var _leadingToken: TokenSyntax?

    public init(newline: Bool)
    {
        self.newline = newline
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        if token.leadingTrivia.hasNewline {
            self._leadingToken = token
        }

        var token2 = token

        if token.tokenKind == .catchKeyword
            || (token.tokenKind == .elseKeyword && !(token.parent is GuardStmtSyntax))
        {
            if let token2_ = self._newlineHandler.run((self._leadingToken, token2)) {
                token2 = token2_
            }
        }

        return super.visit(token2)
    }
}
