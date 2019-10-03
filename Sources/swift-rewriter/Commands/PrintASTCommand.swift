import Foundation
import Curry
import Commandant
import SwiftSyntax
import SwiftRewriter

/// Print AST from file or string.
public struct PrintASTCommand: CommandProtocol
{
    public typealias Options = PrintASTOptions

    public let verb = "print-ast"
    public let function = "print AST from file or string"

    private typealias _Rewriter = SwiftRewriter.Rewriter

    func run(_ options: Options) throws
    {
        var sourceFile: SourceFileSyntax

        if let path = options.path {
            let url = URL(fileURLWithPath: path)
            sourceFile = try _Rewriter.parse(sourceFileURL: url)
        }
        else if let string = options.string {
            sourceFile = try _Rewriter.parse(string: string)
        }
        else {
            return
        }

        if options.enablesBugFix {
            sourceFile = _Rewriter().rewrite(sourceFile)
        }

        print(DebugTree(sourceFile))
    }
}

public struct PrintASTOptions: OptionsProtocol
{
    fileprivate let path: String?
    fileprivate let string: String?
    fileprivate let enablesBugFix: Bool

    public static func evaluate(_ m: CommandMode) -> Result<PrintASTOptions, CommandantError<Swift.Error>>
    {
        return curry(Self.init)
            <*> m <| pathOption(action: "print")
            <*> m <| Option(key: "string", defaultValue: nil, usage: "Swift code to parse")
            <*> m <| Option(key: "enables-bugfix",
                            defaultValue: false,
                            usage: "enables SwiftSyntax bugfix rewriter")
    }
}
