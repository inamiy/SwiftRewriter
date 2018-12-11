import XCTest
@testable import SwiftRewriter

final class IndenterTests: XCTestCase
{
    let indenter = BlockItemIndenter() >>> FirstItemAwareIndenter()

    func test_basic() throws
    {
        let source = """
                struct Foo {
                         init(bool: Bool,
              int: Int) {
                              self.bool = bool
                           if true {
                     print()
                  }

                   run { x in
                            print(x,
                                      y,
                                          z)
                }
                        }
            }
            """

        let expected = """
            struct Foo {
                init(bool: Bool,
                     int: Int) {
                    self.bool = bool
                    if true {
                        print()
                    }

                    run { x in
                        print(x,
                              y,
                              z)
                    }
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: indenter
        )
    }

    // MARK: -

    // MARK: funcDecl

    func test_funcDecl() throws
    {
        let source = """
            struct Foo {
                        func foo(    aaa: Int    ,
              bb: Int  ,
             c: Int ) -> Int {}
            }
            """

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
            using: indenter
        )
    }

    func test_funcDecl_1stArgNewline() throws
    {
        let source = """
            struct Foo {
                        func foo(
               aaa: Int    ,
              bb: Int  ,
             c: Int ) -> Int {}
            }
            """

        let expected = """
            struct Foo {
                func foo(
                    aaa: Int    ,
                    bb: Int  ,
                    c: Int ) -> Int {}
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: indenter
        )
    }

    // MARK: -

    // MARK: funcCall

    func test_funcCall() throws
    {
        let source = """
            print(              aaa    ,
                          bb  ,
                      c )
            """

        let expected = """
            print(              aaa    ,
                                bb  ,
                                c )
            """

        try runTest(
            source: source,
            expected: expected,
            using: indenter
        )
    }

    func test_funcCall_1stArgNewline() throws
    {
        let source = """
            print(
              aaa    ,
                          bb  ,
                      c )
            """

        let expected = """
            print(
                aaa    ,
                bb  ,
                c )
            """

        try runTest(
            source: source,
            expected: expected,
            using: indenter
        )
    }

    func test_funcCall_1stArgNewline_rightParenNewline() throws
    {
        let source = """
            print(
              aaa    ,
                          bb  ,
                      c
                                    )
            """

        let expected = """
            print(
                aaa    ,
                bb  ,
                c
            )
            """

        try runTest(
            source: source,
            expected: expected,
            using: indenter
        )
    }

    // MARK: - Complex Tests

    // TODO:
//    func test_complex() throws
//    {
//        let source = """
//                    let x = 1; func
//                    foo  (   x: Int    ,
//              y: Bool  )   { }
//            """
//
//        let expected = """
//            let x = 1; func
//                foo  (   x: Int    ,
//                         y: Bool  )   { }
//            """
//
//        try runTest(
//            source: source,
//            expected: expected,
//            using: indenter
//        )
//    }

    // MARK: - No Change

    func test_array_trailingComment1() throws
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
            using: indenter
        )
    }

    func test_array_trailingComment2() throws
    {
        let source = """
            let stringOrders: [[Int]] = [
                1,
                2 // hello
            ]
            """

        try runTest(
            source: source,
            expected: source,
            using: indenter
        )
    }
}
