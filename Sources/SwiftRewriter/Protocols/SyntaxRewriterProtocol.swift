import SwiftSyntax

/// Helper protocol to unify `SyntaxRewriter` and `SwiftRewriter.Rewriter`.
public protocol SyntaxRewriterProtocol
{
    func visit(_ node: SourceFileSyntax) -> Syntax
}

extension SyntaxRewriter: SyntaxRewriterProtocol {}

extension Rewriter: SyntaxRewriterProtocol
{
    public func visit(_ node: SourceFileSyntax) -> Syntax
    {
        return self.rewrite(node)
    }
}

/// Left-to-right composition (`l` runs first).
public func >>> <L, R>(l: L, r: R) -> Rewriter
    where L: SyntaxRewriterProtocol, R: SyntaxRewriterProtocol
{
    return Rewriter(l) >>> Rewriter(r)
}
