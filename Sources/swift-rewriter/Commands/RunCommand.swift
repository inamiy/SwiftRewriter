import Foundation
import Result
import Curry
import Commandant
import Files
import SwiftSyntax
import SwiftRewriter

public struct RunCommand: CommandProtocol
{
    public typealias Options = RunOptions

    public let verb = "run"
    public let function = "Auto-correct code in the file or directory"

    func run(_ options: Options) throws
    {
        if let file = try? File(path: options.path) {
            try self._processFile(file, options: options)
        }
        else if let folder = try? Folder(path: options.path) {
            try self._processFolder(folder, options: options)
        }
        else {
            print("no input files or directory")
        }
    }

    private func _processFile(_ file: File, options: Options) throws
    {
        guard file.extension == "swift" else { return }

        let t1 = DispatchTime.now()

        let sourceFile: SourceFileSyntax =
            try Rewriter.parse(sourceFileURL: URL(fileURLWithPath: file.path))

        let t2 = DispatchTime.now()

        let result = rewriter.rewrite(sourceFile)

        let t3 = DispatchTime.now()

        print("Processing file: \(file.path)")

        if options.debug {
            print("=============== time ===============")
            print("total time:", t3 - t1)
            print("  SyntaxTreeParser.parse time:  ", t2 - t1)
            print("  rewriter.rewrite time:", t3 - t2)
            print("=============== result ===============")
            print()
        }
        else {
            try file.write(string: result.description)
        }
    }

    private func _processFolder(_ folder: Folder, options: Options) throws
    {
        for file in folder.makeFileSequence(recursive: true, includeHidden: false) {
            try _processFile(file, options: options)
        }
    }
}

public struct RunOptions: OptionsProtocol
{
    fileprivate let path: String
    fileprivate let debug: Bool

    public static func evaluate(_ m: CommandMode) -> Result<RunOptions, CommandantError<AnyError>>
    {
        return curry(self.init)
            <*> m <| pathOption(action: "run")
            <*> m <| Switch(flag: "d", key: "debug", usage: "DEBUG")
    }
}
