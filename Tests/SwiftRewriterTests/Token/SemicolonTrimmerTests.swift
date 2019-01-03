import XCTest
@testable import SwiftRewriter

final class SemicolonTrimmerTests: XCTestCase
{
    func test_examples() throws
    {
        try runExamples(using: SemicolonTrimmer())
    }
}
