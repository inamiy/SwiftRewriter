import SwiftSyntax

/// Overall indent rewriter.
public struct Indenter: SyntaxRewriterProtocol
{
    private let rewriter: Rewriter

    public init(_ configuration: Configuration)
    {
        let blockItemIndenter = BlockItemIndenter(
            perIndent: configuration.perIndent,
            shouldIndentSwitchCase: configuration.shouldIndentSwitchCase,
            shouldIndentIfConfig: configuration.shouldIndentIfConfig,
            skipsCommentedLine: configuration.skipsCommentedLine,
            usesXcodeStyle: configuration.usesXcodeStyle
        )

        let firstItemAwareIndenter = FirstItemAwareIndenter()

        self.rewriter = blockItemIndenter >>> firstItemAwareIndenter
    }

    public func visit(_ syntax: SourceFileSyntax) -> Syntax
    {
        return self.rewriter.visit(syntax)
    }
}

extension Indenter
{
    public struct Configuration
    {
        public let perIndent: PerIndent
        public let shouldIndentSwitchCase: Bool
        public let shouldIndentIfConfig: Bool
        public let skipsCommentedLine: Bool
        public let usesXcodeStyle: Bool

        public init(
            perIndent: PerIndent = .spaces(4),
            shouldIndentSwitchCase: Bool = false,
            shouldIndentIfConfig: Bool = false,
            skipsCommentedLine: Bool = true,
            usesXcodeStyle: Bool = true
            )
        {
            self.perIndent = perIndent
            self.shouldIndentSwitchCase = shouldIndentSwitchCase
            self.shouldIndentIfConfig = shouldIndentIfConfig
            self.skipsCommentedLine = skipsCommentedLine
            self.usesXcodeStyle = usesXcodeStyle
        }
    }
}
