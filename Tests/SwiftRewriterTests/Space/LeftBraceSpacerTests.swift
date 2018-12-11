import XCTest
@testable import SwiftRewriter

final class LeftBraceSpacerTests: XCTestCase
{
    func test_examples() throws
    {
        for spaceBefore in [false, true] {
            try runExamples(using: LeftBraceSpacer(spaceBefore: spaceBefore))
        }
    }
}
