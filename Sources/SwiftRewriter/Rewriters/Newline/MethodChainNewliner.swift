import SwiftSyntax

open class SyntaxRewriter: SwiftSyntax.SyntaxRewriter
{
    internal var sourceFile: SourceFileSyntax!

    public override func visit(_ syntax: SourceFileSyntax) -> Syntax
    {
        self.sourceFile = syntax
        return super.visit(syntax)
    }
}

/// Add a newline before method-chaining's `dot` if preceding block is multiline.
///
/// # Example
///
///     foo
///         .bar {
///             // long block
///         }.baz
///
/// will have `.baz` be newlined:
///
///     foo
///         .bar {
///             // long block
///         }
///         .baz
///
/// but won't be newlined if not enough "long block",
/// so that one-liner `foo().bar { }.baz` won't be newlined every time.
///
/// - Postcondition: Use `Indenter` for better indent.
open class MethodChainNewliner: SyntaxRewriter
{
    open override func visit(_ syntax: MemberAccessExprSyntax) -> ExprSyntax
    {
        // Skip already newlined `dot`.
        guard !syntax.dot.leadingTrivia.hasNewline else {
            return super.visit(syntax)
        }

        var syntax2 = syntax

        // If `foo.bar().baz` ...
        if let funcCall = syntax2.base as? FunctionCallExprSyntax,
            let memberAccess2 = funcCall.calledExpression as? MemberAccessExprSyntax
        {
            // If `funcCall - memberAccess2` (= func arg content) has multiple lines,
            // let `dot` have a newline.
            if funcCall.numberOfContentLines - memberAccess2.numberOfContentLines > 0 {
                var dot = syntax2.dot
                dot = dot.with(.leadingTrivia, replacingLastSpaces: [.newlines(1)])
                syntax2 = syntax2.withDot(dot)
            }
        }
        // If `foo.bar.baz` or `foo.bar` (no more method-chain) ...
        else {
            // Do nothing.
        }

        return super.visit(syntax2)
    }
}
