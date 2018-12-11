import XCTest
import SnapshotTesting
@testable import SwiftRewriter

/// - Note: This test uses `SnapshotTesting`.
final class CombinedTests: XCTestCase
{
    func test() throws
    {
//        SnapshotTesting.record = true

        try runTestFile("example", using: rewriter)
        try runTestFile("blackjack", using: rewriter)
        try runTestFile("struct-init", using: rewriter)
        try runTestFile("header-comment", using: rewriter)

        do {
            let rewriter = ExtraNewliner()
            try runTestFile("densed", using: rewriter)
        }
    }
}
