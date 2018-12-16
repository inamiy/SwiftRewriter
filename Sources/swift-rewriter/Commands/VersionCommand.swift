import Foundation
import Result
import Curry
import Commandant
import SwiftSyntax
import SwiftRewriter

/// Print current version.
struct VersionCommand: CommandProtocol
{
    public typealias Options = NoOptions<AnyError>

    let verb = "version"
    let function = "Display the current version of SwiftRewriter"

    func run(_ options: Options) throws
    {
        print("0.1.0")
    }
}
