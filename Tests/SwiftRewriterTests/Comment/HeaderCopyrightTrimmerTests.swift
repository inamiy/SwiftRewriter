import XCTest
@testable import SwiftRewriter

final class HeaderCopyrightTrimmerTests: XCTestCase
{
    func test_basic() throws
    {
        let source = """
            //
            //  example.swift
            //  SwiftRewriter
            //
            //  Created by Yasuhiro Inami on 2018-12-09.
            //  Copyright © 2018 Yasuhiro Inami. All rights reserved.
            //

            // hello
            """

        let expected = """
            // hello
            """

        try runTest(
            source: source,
            expected: expected,
            using: HeaderCopyrightTrimmer()
        )
    }

    func test_basic2() throws
    {
        let source = """
            //
            //  example.swift
            //  SwiftRewriter
            //
            //  Created by Yasuhiro Inami on 2018-12-09.
            //  Copyright © 2018 Yasuhiro Inami. All rights reserved.
            //

            /// doc

            /**
             * doc2
             */
            public func hello() {}
            """

        let expected = """
            /// doc

            /**
             * doc2
             */
            public func hello() {}
            """


        try runTest(
            source: source,
            expected: expected,
            using: HeaderCopyrightTrimmer()
        )
    }

    // MARK: - No Change

    func test_noChange() throws
    {
        let source = """
            // IMPORTANT NOTICE

            /// doc

            /**
             * doc2
             */
            public func hello() {}
            """

        try runTest(
            source: source,
            expected: source,
            using: HeaderCopyrightTrimmer()
        )
    }
}
