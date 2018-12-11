import XCTest
@testable import SwiftRewriter

final class ColonSpacerTests: XCTestCase
{
    func test_examples() throws
    {
        for spaceBefore in [false, true] {
            for spaceAfter in [false, true] {
                try runExamples(using: ColonSpacer(spaceBefore: spaceBefore, spaceAfter: spaceAfter))
            }
        }
    }

    func test_spaceBeforeFalse_spaceAfterFalse() throws
    {
        let source = """
            struct Foo<T : Decodable> {
                let int : Int
                init(int : Int) {
                    self.int = [key : value]
                }
            }
            """

        let expected = """
            struct Foo<T:Decodable> {
                let int:Int
                init(int:Int) {
                    self.int = [key:value]
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ColonSpacer(spaceBefore: false, spaceAfter: false)
        )
    }

    func test_spaceBeforeFalse_spaceAfterTrue() throws
    {
        let source = """
            struct Foo<T : Decodable> {
                let int:Int
                init(int:Int) {
                    self.int = [key:value]
                }
            }
            """

        let expected = """
            struct Foo<T: Decodable> {
                let int: Int
                init(int: Int) {
                    self.int = [key: value]
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ColonSpacer(spaceBefore: false, spaceAfter: true)
        )
    }

    func test_spaceBeforeTrue_spaceAfterFalse() throws
    {
        let source = """
            struct Foo<T: Decodable> {
                let int: Int
                init(int : Int) {
                    self.int = [key: value]
                }
            }
            """

        let expected = """
            struct Foo<T :Decodable> {
                let int :Int
                init(int :Int) {
                    self.int = [key :value]
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ColonSpacer(spaceBefore: true, spaceAfter: false)
        )
    }

    func test_spaceBeforeTrue_spaceAfterTrue() throws
    {
        let source = """
            struct Foo<T:Decodable> {
                let int:Int
                init(int: Int) {
                    self.int = [key:value]
                }
            }
            """

        let expected = """
            struct Foo<T : Decodable> {
                let int : Int
                init(int : Int) {
                    self.int = [key : value]
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ColonSpacer(spaceBefore: true, spaceAfter: true)
        )
    }

    // MARK: - TernaryExpr
    // NOTE: `ColonSpacer` is not useful for `TernaryExpr` since it may be multiline.

    func test_ternaryExpr() throws
    {
        let source = """
            let foo = flag ? true   :   false
            """

        let expected = """
            let foo = flag ? true : false
            """

        try runTest(
            source: source,
            expected: expected,
            using: ColonSpacer(spaceBefore: true, spaceAfter: true)
        )
    }

    func test_ternaryExpr2() throws
    {
        let source = """
            let foo = flag
                ? true
                :    false
            """

        let expected = """
            let foo = flag
                ? true␣
                : false
            """

        try runTest(
            source: source,
            expected: expected,
            using: ColonSpacer(spaceBefore: true, spaceAfter: true)
        )
    }

    // MARK: - No Change

    func test_attribute() throws
    {
        let source = """
            @objc(foo:bar:)
            func foo(_ x: Int, bar: Int) {}
            """

        try runTest(
            source: source,
            expected: source,
            using: ColonSpacer(spaceBefore: false, spaceAfter: true)
        )
    }
}
