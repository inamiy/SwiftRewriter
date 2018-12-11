import XCTest
@testable import SwiftRewriter

final class ExtraSpaceTrimmerTests: XCTestCase
{
    func test_basic() throws
    {
        let source = """
            struct␣␣␣Foo␣␣␣{
                let␣␣␣int␣␣␣:␣␣␣Int
                init␣␣(int:␣␣Int)␣␣{
                    self.int␣␣=␣␣int
                }
            }
            """

        let expected = """
            struct Foo {
                let int : Int
                init (int: Int) {
                    self.int = int
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ExtraSpaceTrimmer()
        )
    }

    func test_comment() throws
    {
        let source = """
            struct␣␣␣Foo␣␣␣{␣␣␣// foo
                let␣␣␣int␣␣␣:␣␣␣Int␣␣␣// foo2
                init␣␣(int:␣␣Int)␣␣{␣␣␣// foo3
                    self.int␣␣=␣␣int␣␣␣// foo4
                }␣␣␣// foo5
            }␣␣␣// foo6
            """

        let expected = """
            struct Foo {␣␣␣// foo
                let int : Int␣␣␣// foo2
                init (int: Int) {␣␣␣// foo3
                    self.int = int␣␣␣// foo4
                }␣␣␣// foo5
            }␣␣␣// foo6
            """

        try runTest(
            source: source,
            expected: expected,
            using: ExtraSpaceTrimmer()
        )
    }
}
