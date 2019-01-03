import SwiftSyntax

/// Insert `_`s for every 3-digits in decimal literal.
open class DecimalLiteralUnderscorer: SyntaxRewriter, HasRewriterExamples
{
    var rewriterExamples: [String: String]
    {
        return [
            "1000": "1_000",
            "1000000": "1_000_000",
            "1_0_0_0": "1_000",
        ]
    }

    var rewriterNoChangeExamples: [String]
    {
        return [
            "123",
            "1_000",
            "0x1000",
            "0b1000",
            "0o1000",
            "1234.5"
        ]
    }

    open override func visit(_ token: TokenSyntax) -> Syntax
    {
        guard case var .integerLiteral(text) = token.tokenKind else { return token }

        // Ignore non-decimal-literals.
        if text.hasPrefix("0x") || text.hasPrefix("0b") || text.hasPrefix("0o") {
            return token
        }

        text = text.replacingOccurrences(of: "_", with: "")

        let index1 = text.index(after: text.startIndex)
        var index = text.endIndex
        while text.formIndex(&index, offsetBy: -3, limitedBy: index1) {
            text.insert("_", at: index)
        }

        return token.withKind(.integerLiteral(text))
    }
}
