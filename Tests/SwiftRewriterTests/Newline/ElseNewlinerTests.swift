import XCTest
@testable import SwiftRewriter

final class ElseNewlinerTests: XCTestCase
{
    // MARK: - if-else newlining

    func test_ifElse_newline_true() throws
    {
        let source = """
            do {
                if true {
                } else {
                }
            }
            """

        let expected = """
            do {
                if true {
                }␣
                else {
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ElseNewliner(newline: true)
        )
    }

    func test_ifElse_newline_false() throws
    {
        let source = """
            do {
                if true {
                }
                else {
                }
            }
            """

        let expected = """
            do {
                if true {
                } else {
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ElseNewliner(newline: false)
        )
    }

    // MARK: - guard-else (not supported yet)

    /// - Note: `guard-else` is not supported yet.
    func test_guardElse_newline_true() throws
    {
        let source = """
            do {
                guard true else {
                }
            }
            """

        try runTest(
            source: source,
            expected: source,
            using: ElseNewliner(newline: true)
        )
    }

    /// - Note: `guard-else` is not supported yet.
    func test_guardElse_newline_false() throws
    {
        let source = """
            do {
                guard true
                    else {
                    }
            }
            """

        try runTest(
            source: source,
            expected: source,
            using: ElseNewliner(newline: true)
        )
    }

    // MARK: - do-catch newlining

    func test_catch_newline_true() throws
    {
        let source = """
            do {
                do {
                } catch {
                }
            }
            """

        let expected = """
            do {
                do {
                }␣
                catch {
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ElseNewliner(newline: true)
        )
    }

    func test_catch_newline_false() throws
    {
        let source = """
            do {
                do {
                }
                catch {
                }
            }
            """

        let expected = """
            do {
                do {
                } catch {
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ElseNewliner(newline: false)
        )
    }
}
