import XCTest
@testable import SwiftRewriter

final class MethodChainNewlinerTests: XCTestCase
{
    func test_closure1() throws
    {
        let source = """
            a
                .b {
                }.c
            """

        let expected = """
            a
                .b {
                }
            .c
            """

        try runTest(
            source: source,
            expected: expected,
            using: MethodChainNewliner()
        )
    }

    func test_closure2() throws
    {
        let source = """
            a
                .b {
                }.c {
                }
            """

        let expected = """
            a
                .b {
                }
            .c {
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: MethodChainNewliner()
        )
    }

    func test_arg1() throws
    {
        let source = """
            a
                .b(
                ).c
            """

        let expected = """
            a
                .b(
                )
            .c
            """

        try runTest(
            source: source,
            expected: expected,
            using: MethodChainNewliner()
        )
    }

    func test_arg2() throws
    {
        let source = """
            a
                .b(
                ).c(
                )
            """

        let expected = """
            a
                .b(
                )
            .c(
                )
            """

        try runTest(
            source: source,
            expected: expected,
            using: MethodChainNewliner()
        )
    }

    // MARK: - No Change

    func test_noChange1() throws
    {
        let source = """
            a.b.c
            """

        try runTest(
            source: source,
            expected: source,
            using: MethodChainNewliner()
        )
    }

    /// - Note: `b`'s closure requires
    func test_noChange2() throws
    {
        let source = """
            a
                .b {}.c
            """

        try runTest(
            source: source,
            expected: source,
            using: MethodChainNewliner()
        )
    }

    func test_noChange3() throws
    {
        let source = """
            a
                .b {}.c {
                }
            """

        try runTest(
            source: source,
            expected: source,
            using: MethodChainNewliner()
        )
    }

    func test_noChange4() throws
    {
        let source = """
            a
                .b().c
            """

        try runTest(
            source: source,
            expected: source,
            using: MethodChainNewliner()
        )
    }

    func test_noChange5() throws
    {
        let source = """
            a
                .b().c(
                )
            """

        try runTest(
            source: source,
            expected: source,
            using: MethodChainNewliner()
        )
    }
}
