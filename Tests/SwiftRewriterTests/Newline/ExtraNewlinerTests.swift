import XCTest
@testable import SwiftRewriter

final class ExtraNewlinerTests: XCTestCase
{
    func test_simple() throws
    {
        let source = """
            import Foundation
            func foo() {}

            """

        let expected = """
            import Foundation

            func foo() {}

            """

        try runTest(
            source: source,
            expected: expected,
            using: ExtraNewliner()
        )
    }

    func test_simple2() throws
    {
        let source = """
            import Foundation


            func foo() {}

            """

        let expected = """
            import Foundation

            func foo() {}

            """

        try runTest(
            source: source,
            expected: expected,
            using: ExtraNewliner()
        )
    }

    func test_long() throws
    {
        let source = """
            import Foundation
            var computed1: Int = 1
            var computed2: Int = { return 2 }
            /// doc
            var computed3: Int = { return 3 }
            /// doc
            var computedBlock: String {
                return ""
            }
            func send() -> Observable<Void> {
                return apiSession
                    .send(request)
                    .do(onError: { [weak self] error in
                        guard let me = self else { return }
                        me.doSomething()
                    })
                    .do(onError: { [weak self] error in
                        guard let me = self else { return }
                        me.doSomething()
                        me.doSomething()
                    })
            }
            """

        let expected = """
            import Foundation

            var computed1: Int = 1
            var computed2: Int = { return 2 }

            /// doc
            var computed3: Int = { return 3 }

            /// doc
            var computedBlock: String {
                return ""
            }

            func send() -> Observable<Void> {
                return apiSession
                    .send(request)
                    .do(onError: { [weak self] error in
                        guard let me = self else { return }
                        me.doSomething()
                    })
                    .do(onError: { [weak self] error in
                        guard let me = self else { return }

                        me.doSomething()
                        me.doSomething()
                    })
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: ExtraNewliner()
        )
    }

    // MARK: - No Change

    func test_noChange() throws
    {
        let source = """
            import Foundation

            func foo() {}
            """

        try runTest(
            source: source,
            expected: source,
            using: ExtraNewliner()
        )
    }

    func test_noChange2() throws
    {
        let source = """
            /// doc
            func foo()

            // MARK: - Mark

            /// doc
            func foo2()
            """

        try runTest(
            source: source,
            expected: source,
            using: ExtraNewliner()
        )
    }
}
