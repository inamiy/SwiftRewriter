import XCTest
@testable import SwiftRewriter

final class DecimalLiteralUnderscorerTests: XCTestCase
{
    func test_examples() throws
    {
        try runExamples(using: DecimalLiteralUnderscorer())
    }
}
