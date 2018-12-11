import XCTest
@testable import SwiftRewriter

final class BinaryOperatorSpacerTests: XCTestCase
{
    func test_examples() throws
    {
        for spacesAround in [false, true] {
            try runExamples(using: BinaryOperatorSpacer(spacesAround: spacesAround))
        }
    }
}
