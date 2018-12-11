import XCTest
@testable import SwiftRewriter

final class FirstItemAwareIndenterTests: XCTestCase
{
    func test_funcDecl() throws
    {
        let source = """
            struct Foo {
                        func foo(    aaa: Int    ,
              bb: Int  ,
             c: Int ) -> Int {}
            }
            """

        /// - Note: First line still has a good indent.
        let expected = """
            struct Foo {
                        func foo(    aaa: Int    ,
                                     bb: Int  ,
                                     c: Int ) -> Int {}
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_funcCall() throws
    {
        let source = """
                print(    aaa    ,
              bb  ,
             c )
            """

        let expected = """
                print(    aaa    ,
                          bb  ,
                          c )
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_func_complex() throws
    {
        let source = """
                    let x = 1; func
                    foo  (   x: Int    ,
              y: Bool  )   { }
            """

        let expected = """
                    let x = 1; func
                    foo  (   x: Int    ,
                             y: Bool  )   { }
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_switch() throws
    {
        let source = """
            public class Foo {
                func foo(c: Case) {
                    switch c {
                    case .case0:
                        break
                    case /* hello */ .case1,
                    ␣␣␣␣.case2:
                        break
                    default:
                        break
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(c: Case) {
                    switch c {
                    case .case0:
                        break
                    case /* hello */ .case1,
                        ␣␣␣␣␣␣␣␣␣␣␣␣␣.case2:
                        break
                    default:
                        break
                    }
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_array1() throws
    {
        let source = """
            let arr: [Int] = [1,
            2,
            /* hello */]
            """

        let expected = """
            let arr: [Int] = [1,
                              2,
                              /* hello */]
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_array2() throws
    {
        let source = """
            let arr: [Int] = [1,
            2,
            3 /* hello */]
            """

        let expected = """
            let arr: [Int] = [1,
                              2,
                              3 /* hello */]
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_array3() throws
    {
        let source = """
            let arr: [Int] = [
                1,
                2,
                /* hello */
            ]
            """

        try runTest(
            source: source,
            expected: source,
            using: FirstItemAwareIndenter()
        )
    }

    func test_array4() throws
    {
        let source = """
            let stringOrders: [[Int]] = [
                1,
                2,
                3 // hello
            ]
            """

        try runTest(
            source: source,
            expected: source,
            using: FirstItemAwareIndenter()
        )
    }

    func test_dictionary1() throws
    {
        let source = """
            let dic: [Int: Bool] = [1: true,
            2: false,
            /* hello */]
            """

        let expected = """
            let dic: [Int: Bool] = [1: true,
                                    2: false,
                                    /* hello */]
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_dictionary2() throws
    {
        let source = """
            return [
                1: true
            //    2: false
            ]
            """

        try runTest(
            source: source,
            expected: source,
            using: FirstItemAwareIndenter()
        )
    }

    func test_tuplePatternElementList() throws
    {
        let source = """
            let (a,
            b,
            c) = x
            """

        let expected = """
            let (a,
                 b,
                 c) = x
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_tupleTypeElementList() throws
    {
        let source = """
            func foo() -> (a: A,
            b: B,
            c: C) {
            }
            """

        let expected = """
            func foo() -> (a: A,
                           b: B,
                           c: C) {
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    func test_tupleElementList() throws
    {
        let source = """
            return (left: 0,
            right: 0)
            """

        let expected = """
            return (left: 0,
                    right: 0)
            """

        try runTest(
            source: source,
            expected: expected,
            using: FirstItemAwareIndenter()
        )
    }

    // MARK: - No Change

    func test_noChange() throws
    {
        let source = """
            struct Foo {
                init(bool: Bool) {
                    self.bool = bool
                    run { x in print(x) /* trivia */     }
                }
            }
            """

        try runTest(
            source: source,
            expected: source,
            using: FirstItemAwareIndenter()
        )
    }
}
