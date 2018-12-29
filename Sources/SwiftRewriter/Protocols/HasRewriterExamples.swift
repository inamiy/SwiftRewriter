import SwiftSyntax

/// Supporting protocol for simple tests.
protocol HasRewriterExamples
{
    /// Dictionary representing syntax changes from `key` to `value`.
    var rewriterExamples: [String: String] { get }

    /// Array representing no syntax changes.
    var rewriterNoChangeExamples: [String] { get }
}

extension HasRewriterExamples
{
    /// Default implementation.
    var rewriterNoChangeExamples: [String]
    {
        return []
    }
}

extension HasRewriterExamples
{
    /// `rewriterExamples` + `rewriterNoChangeExamples` for testing.
    var rewriterAllExamples: [String: String]
    {
        let noChanges = [String: String](
            rewriterNoChangeExamples.map { ($0, $0) },
            uniquingKeysWith: { $1 }
        )

        return rewriterExamples
            .merging(noChanges, uniquingKeysWith: { $1 })
    }
}
