import XCTest
@testable import SwiftRewriter

final class LeftParenSpacerTests: XCTestCase
{
    func test_examples() throws
    {
        try runExamples(using: LeftParenSpacer())
    }
}
