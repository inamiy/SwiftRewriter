import SwiftSyntax

// MARK: - Debug Print

enum Debug
{
    /// `Debug.print`.
    static func print(_ x: Any)
    {
        #if DEBUG
        Swift.print(x)
        #endif
    }
}

// MARK: - Debug String

extension Syntax
{
    /// Short debugging string.
    var shortDebugString: String
    {
        return String(self.description.drop(while: { $0 == " " || $0 == "\n" }))
    }

    /// Detailed debugging string.
    var debugString: String
    {
        let token = self as? TokenSyntax

        let infos: [(String, Any?)] = [
            ("type", type(of: self)),
            ("text", self.description),
            ("tokenKind", token?.tokenKind),
            ("isStmt", self.isStmt),
            ("leadingTrivia", self.leadingTrivia),
            ("trailingTrivia", self.trailingTrivia),
            ("leadingTriviaLength", self.leadingTriviaLength),
            ("trailingTriviaLength", self.trailingTriviaLength),
            ("position", self.position),
            ("positionAfterSkippingLeadingTrivia", self.positionAfterSkippingLeadingTrivia),
            ("endPosition", self.endPosition),
            ("endPositionAfterTrailingTrivia", self.endPositionAfterTrailingTrivia)
            ]

        let infos2 = infos
            .compactMap { (tuple) -> (String, Any)? in
                let (key, value) = tuple

                if let value = value {
                    return (key, value)
                }
                else {
                    return nil
                }
            }

        let infoString = "\n[debugString]\n"
            + infos2
                .map { "  \($0) = \($1)" }
                .joined(separator: "\n")

        return infoString
    }
}
