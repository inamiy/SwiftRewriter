import XCTest
@testable import SwiftRewriter

final class ArrowSpacerTests: XCTestCase
{
    func test_examples() throws
    {
        for spaceBefore in [false, true] {
            for spaceAfter in [false, true] {
                try runExamples(using: ArrowSpacer(spaceBefore: spaceBefore, spaceAfter: spaceAfter))
            }
        }
    }
}
