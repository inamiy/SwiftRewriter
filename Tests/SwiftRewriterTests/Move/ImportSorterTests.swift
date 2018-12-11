import XCTest
@testable import SwiftRewriter

final class ImportSorterTests: XCTestCase
{
    func test_basic() throws
    {
        let source = """
            import C
            import B

            func foo() {}

            import A
            import D
            """

        let expected = """
            import A
            import B
            import C
            import D

            func foo() {}
            """

        try runTest(
            source: source,
            expected: expected,
            using: ImportSorter()
        )
    }
}
