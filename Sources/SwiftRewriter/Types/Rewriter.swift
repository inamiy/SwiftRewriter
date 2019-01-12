import Foundation
import SwiftSyntax

/// `SyntaxRewriter.visit` wrapper.
public struct Rewriter
{
    public let rewrite: (SourceFileSyntax) -> SourceFileSyntax

    public init(format: @escaping (SourceFileSyntax) -> SourceFileSyntax)
    {
        self.rewrite = format
    }

    public init<T: SyntaxRewriterProtocol>(_ rewriter: T)
    {
        self.rewrite = { rewriter.visit($0) as! SourceFileSyntax }
    }

    // MARK: Category

    /// Unit element.
    static var id: Rewriter
    {
        return Rewriter(format: { $0 })
    }

    /// Left-to-right composition (`l` runs first).
    static func >>> (l: Rewriter, r: Rewriter) -> Rewriter
    {
        return Rewriter { r.rewrite(l.rewrite($0)) }
    }
}

extension Rewriter: ExpressibleByArrayLiteral
{
    public init(arrayLiteral elements: Rewriter...)
    {
        self = elements.reduce(into: Rewriter.id) { $0 = $0 >>> $1 }
    }
}

// MARK: Helpers

extension Rewriter
{
    public static func parse(sourceFileURL: URL) throws -> SourceFileSyntax
    {
        return try SyntaxParser.parse(sourceFileURL)
    }

    public static func parse(string: String) throws -> SourceFileSyntax
    {
        let sourceFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("swift")

        try string.write(to: sourceFileURL, atomically: true, encoding: .utf8)

        return try self.parse(sourceFileURL: sourceFileURL)
    }
}
