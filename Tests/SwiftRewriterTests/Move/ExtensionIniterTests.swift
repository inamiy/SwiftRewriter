import XCTest
@testable import SwiftRewriter

final class ExtensionIniterTests: XCTestCase
{
    func test_basic() throws
    {
        let source = """
            struct Foo {
                let int: Int
                init(int: Int) {
                    self.int = int
                }
                init() {
                    self.int = 0
                }
            }
            """

        let expected = """
            struct Foo {
                let int: Int
            }

            extension Foo {
                init(int: Int) {
                    self.int = int
                }
                init() {
                    self.int = 0
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ExtensionIniter()
        )
    }

    func test_nestedStruct() throws
    {
        let source = """
            struct Foo {
                let int: Int
                init(int: Int) {
                    self.int = int
                }
                struct Bar {
                    let bool: Bool
                    init(bool: Bool) {
                        self.bool = bool
                    }
                }
            }
            """

        let expected = """
            struct Foo {
                let int: Int
                struct Bar {
                    let bool: Bool
                }
            }

            extension Foo {
                init(int: Int) {
                    self.int = int
                }
            }

            extension Foo.Bar {
                    init(bool: Bool) {
                        self.bool = bool
                    }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ExtensionIniter()
        )
    }
}
