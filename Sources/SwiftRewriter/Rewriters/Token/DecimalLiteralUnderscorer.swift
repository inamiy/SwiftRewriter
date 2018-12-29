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

    open override func visit(_ syntax: IntegerLiteralExprSyntax) -> ExprSyntax
    {
        var text = syntax.digits.text

        // Ignore non-decimal-literals.
        if text.hasPrefix("0x")
            || text.hasPrefix("0b")
            || text.hasPrefix("0o")
        {
            return super.visit(syntax)
        }

        text = text.replacingOccurrences(of: "_", with: "")

        let limitedIndex = text.index(after: text.startIndex) // index = 1
        var index = text.endIndex
        while true {
            if text.formIndex(&index, offsetBy: -3, limitedBy: limitedIndex) {
                text.insert("_", at: index)
            }
            else {
                break
            }
        }

        let digits2 = syntax.digits.withKind(TokenKind.integerLiteral(text))

        return super.visit(syntax.withDigits(digits2))
    }
}
