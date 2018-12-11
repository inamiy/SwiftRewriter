import XCTest
@testable import SwiftRewriter

final class EqualSpacerTests: XCTestCase
{
    func test_examples() throws
    {
        for spacesAround in [false, true] {
            try runExamples(using: EqualSpacer(spacesAround: spacesAround))
        }
    }
}
