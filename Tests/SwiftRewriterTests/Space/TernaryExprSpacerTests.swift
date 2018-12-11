import XCTest
@testable import SwiftRewriter

final class TernaryExprSpacerTests: XCTestCase
{
    func test_examples() throws
    {
        try runExamples(using: TernaryExprSpacer())
    }
}
