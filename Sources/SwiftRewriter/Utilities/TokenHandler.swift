import SwiftSyntax

/// Composable & failurable token hander.
typealias TokenHandler = OptionalKleisli<TokenSyntax, TokenSyntax>

/// Kleisli arrows of `Optional` monad.
struct OptionalKleisli<A, B>
{
    let run: (A) -> B?

    init(_ run: @escaping (A) -> B?)
    {
        self.run = run
    }

    /// i.e. `f >=> self`
    func preprocess<A2>(_ f: @escaping (A2) -> A?) -> OptionalKleisli<A2, B>
    {
        return OptionalKleisli<A2, B> {
            f($0).flatMap { self.run($0) }
        }
    }

    /// i.e. `self >=> f`
    func postprocess<B2>(_ f: @escaping (B) -> B2?) -> OptionalKleisli<A, B2>
    {
        return OptionalKleisli<A, B2> {
            self.run($0).flatMap { f($0) }
        }
    }

    // MARK: Category

    static var id: OptionalKleisli<A, A>
    {
        return OptionalKleisli<A, A> { Optional($0) }
    }

    static func >>> <C>(l: OptionalKleisli<A, B>, r: OptionalKleisli<B, C>) -> OptionalKleisli<A, C>
    {
        return l.postprocess(r.run)
    }

    // MARK: ArrowZero / ArrowPlus

    static var zero: OptionalKleisli<A, B>
    {
        return OptionalKleisli<A, B> { _ in .none }
    }

    static func <+> (l: OptionalKleisli<A, B>, r: OptionalKleisli<A, B>) -> OptionalKleisli<A, B>
    {
        return OptionalKleisli<A, B> { token in
            if let token2 = l.run(token) {
                return token2
            }
            else {
                return r.run(token)
            }
        }
    }
}

// MARK: - Constructors

extension OptionalKleisli
{
    /// Check validity of the token handling, or fail.
    static func check(_ f: @escaping (TokenSyntax) -> Bool) -> TokenHandler
    {
        return TokenHandler { f($0) ? $0 : nil }
    }

    /// Replace `trailingTrivia`'s last spaces at last.
    static func handleTrailingSpacesBefore(
        shouldInsert: Bool,
        preprocess: TokenHandler = .id
        ) -> TokenHandler
    {
        return _checkTrailingSpace(shouldInsert: shouldInsert)
            >>> preprocess
            >>> _handleTrailingSpacesBefore(shouldInsert: shouldInsert)
    }

    /// Replace `trailingTrivia`'s first spaces at last.
    static func handleTrailingSpacesAfter(
        shouldInsert: Bool,
        preprocess: TokenHandler = .id
        ) -> TokenHandler
    {
        return _checkTrailingSpace(shouldInsert: shouldInsert)
            >>> preprocess
            >>> _handleTrailingSpacesAfter(shouldInsert: shouldInsert)
    }

    /// Check `trailingTrivia` spaces, or fail.
    private static func _checkTrailingSpace(shouldInsert: Bool) -> TokenHandler
    {
        return shouldInsert
            ? .check { $0.trailingTrivia.description != " " }    // TODO: `Trivia: Equatable`
            : .check { $0.trailingTriviaLength.utf8Length > 0 }
    }

    /// Replace `trailingTrivia`'s last spaces.
    private static func _handleTrailingSpacesBefore(shouldInsert: Bool) -> TokenHandler
    {
        return shouldInsert
            ? TokenHandler { $0.with(.trailingTrivia, replacingLastSpaces: 1) }
            : TokenHandler { $0.with(.trailingTrivia, replacingLastSpaces: 0) }
    }

    /// Replace `trailingTrivia`'s first spaces.
    private static func _handleTrailingSpacesAfter(shouldInsert: Bool) -> TokenHandler
    {
        return shouldInsert
            ? TokenHandler { $0.with(.trailingTrivia, replacingFirstSpaces: 1) }
            : TokenHandler { $0.with(.trailingTrivia, replacingFirstSpaces: 0) }
    }
}
