import SwiftSyntax
import XCTest
import SnapshotTesting
@testable import SwiftRewriter

// MARK: - Test Runners

func runExamples<T>(
    using rewriter: T,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line
    ) throws
    where T: SyntaxRewriterProtocol & HasRewriterExamples
{
    try rewriter.rewriterAllExamples
        .sorted(by: { $0.key < $1.key || ($0.key == $1.key && $0.value < $1.value) }) // lexicographical order
        .forEach { source, expected in
            try runTest(source: source, expected: expected, using: rewriter,
                        file: file, function: function, line: line)
        }
}

func runTest<T>(
    source: String,
    expected: String,
    using rewriter: T,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line
    ) throws
    where T: SyntaxRewriterProtocol
{
    /// Tweak special characters.
    func tweak(_ string: String) -> String
    {
        return string.replacingOccurrences(of: "␣", with: " ")
    }

    let syntax = try parseString(tweak(source))

    let result = Rewriter(rewriter).rewrite(syntax).description

    let diffString = Diffing<String>.lines.diff(tweak(expected), result)?.0

    print(border("source"))
    print(source)
    print(border("result"))
    print(result)
    print(border("expected"))
    print(expected)
    print(border("diff"))
    print(diffString ?? "(no diff)")
    print(border("done"))
    print()

    if let diffString = diffString {
        XCTFail(diffString, file: file, line: line)
    }
}

/// Test `{testFileDirectory}/__TestSources__/{testFileName}/{function}.{filename}.swift`
/// by comparing with snapshot in
/// `{testFileDirectory}/__Snapshots__/{testFileName}/{function}.{filename}.swift`.
func runTestFile<T>(
    _ sourceFileName: String,
    using rewriter: T,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line
    ) throws
    where T: SyntaxRewriterProtocol
{
    let syntax = try parseTestFile(filename: sourceFileName, file: file, function: function, line: line)

    let result = Rewriter(rewriter).rewrite(syntax)

    // Snapshot Testing
    assertSnapshot(matching: result, as: .swiftLines, named: sourceFileName, record: false, timeout: 5,
                   file: file, testName: function, line: line)

    print(border("source"))
    print(syntax.description)
    print(border("result"))
    print(result.description)
    print(border("done"))
    print()
}

// MARK: - Parse string or file

/// - Note: Including `BugFixer`.
func parseString(_ source: String) throws -> SourceFileSyntax
{
    let sourceURL = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(UUID().uuidString)
        .appendingPathExtension("swift")

    try source.write(to: sourceURL, atomically: true, encoding: .utf8)

    let syntax = try SyntaxTreeParser.parse(sourceURL)

    return BugFixer().parse(syntax)
}

/// Parse test file in
/// `{CurrentTestFileDirectory}/__TestSources__/{CurrentTestFileName}/test.{filename}.swift`.
///
/// - Note: Including `BugFixer`.
func parseTestFile(
    filename sourceFileName: String,
    file: StaticString,
    function: String,
    line: UInt
    ) throws -> SourceFileSyntax
{
    let fileUrl = URL(fileURLWithPath: "\(file)")
    let fileName = fileUrl.deletingPathExtension().lastPathComponent
    let directoryUrl = fileUrl.deletingLastPathComponent()
    let testSourcesDirectoryUrl: URL = directoryUrl
        .appendingPathComponent("__TestSources__")
        .appendingPathComponent(fileName)
    let testSourceFileUrl = testSourcesDirectoryUrl
        .appendingPathComponent("\(function.dropLast(2)).\(sourceFileName)")
        .appendingPathExtension("swift")

    let syntax = try SyntaxTreeParser.parse(testSourceFileUrl)

    return BugFixer().parse(syntax)
}

// MARK: - Private

extension SyntaxRewriter
{
    fileprivate func parse(_ syntax: SourceFileSyntax) -> SourceFileSyntax
    {
        return self.visit(syntax) as! SourceFileSyntax
    }
}

extension Snapshotting where Value == SourceFileSyntax, Format == String
{
    /// Export snapshot as `.swift` file.
    fileprivate static let swiftLines: Snapshotting =
        Snapshotting<String, String>(pathExtension: "swift", diffing: .lines)
            .pullback { $0.description }
}

private func border(_ string: String) -> String
{
    let line = String(repeating: "=", count: max(3, 20 - string.count / 2))
    return "\(line) \(string) \(line)"
}
