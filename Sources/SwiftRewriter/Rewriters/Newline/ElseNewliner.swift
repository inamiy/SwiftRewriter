import SwiftSyntax

/// Insert or remove a newline between `if-else` and `do-catch`.
/// - Warning: `guard-else` is not supported yet.
/// - Note: Ignores statement that contains comments in between.
open class ElseNewliner: SyntaxRewriter
{
    private typealias _TokensHandler = OptionalKleisli<(leadingToken: TokenSyntax?, currentToken: TokenSyntax), TokenSyntax>

    private let _newlineHandler: _TokensHandler

    private var _leadingToken: TokenSyntax?

    public init(newline: Bool)
    {
        func makeTokenHandler(shouldInsert: Bool) -> _TokensHandler
        {
            if shouldInsert {
                return _TokensHandler { leadingToken, token in
                    guard token.leadingTriviaLength.newlines == 0
                        && token.leadingTrivia.allSatisfy({ !$0.isComment }) else
                    {
                        return nil
                    }

                    let indentSpaces = (leadingToken?.positionAfterSkippingLeadingTrivia.column ?? 1) - 1
                    return token.withLeadingTrivia(.newlines(1) + .spaces(indentSpaces))
                }
            }
            else {
                return _TokensHandler { leadingToken, token in
                    guard token.leadingTriviaLength.newlines > 0
                        && token.leadingTrivia.allSatisfy({ !$0.isComment }) else {
                        return nil
                    }

                    return token.withLeadingTrivia(.spaces(1))
                }
            }
        }

        self._newlineHandler = makeTokenHandler(shouldInsert: newline)
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        if token.leadingTriviaLength.newlines > 0 {
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
