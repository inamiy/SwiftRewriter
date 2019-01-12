import SwiftLang
import Foundation
import Result
import Curry
import Commandant
import Files
import SwiftSyntax
import SwiftRewriter

/// Swift 5's `SwiftLang` (sourcekit) + `ByteTree` based `run` command.
///
/// - Precondition: Requires `swift-DEVELOPMENT-SNAPSHOT-2019-01-05-a` or above.
/// - SeeAlso: https://github.com/apple/swift/tree/master/tools/SourceKit/tools/swift-lang
public struct RunSwift5Command: CommandProtocol
{
    public typealias Options = RunSwift5Options

    public let verb = "run-swift5"
    public let function = "`run` using Swift 5 toolchain (experimental)"

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

        let treeData = try SwiftLang.parse(
            contentsOf: URL(fileURLWithPath: file.path),
            into: options.format.treeFormat
        )

        let t2 = DispatchTime.now()

        let deserializer = SyntaxTreeDeserializer()
        let sourceFile = try deserializer.deserialize(treeData, serializationFormat: options.format)

        let t3 = DispatchTime.now()

        let result = rewriter.rewrite(sourceFile)

        let t4 = DispatchTime.now()

        print("Processing file: \(file.path)")

        if options.debug {
            print("=============== time ===============")
            print("total time:", t4 - t1)
            print("  parse + deserialize:", t3 - t1)
            print("    SwiftLang.parse time:  ", t2 - t1)
            print("    deserialize time:", t3 - t2)
            print("  rewriter.rewrite time:", t4 - t3)
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

public struct RunSwift5Options: OptionsProtocol
{
    fileprivate let path: String
    fileprivate let format: SerializationFormat
    fileprivate let debug: Bool

    public static func evaluate(_ m: CommandMode) -> Result<RunSwift5Options, CommandantError<AnyError>>
    {
        return curry(self.init)
            <*> m <| pathOption(action: "run-swift5")
            <*> m <| Option.init(key: "format", defaultValue: .byteTree, usage: "Serialization format")
            <*> m <| Switch(flag: "d", key: "debug", usage: "DEBUG")
    }
}

// MARK: - SwiftSyntax.SerializationFormat

extension SerializationFormat: ArgumentProtocol
{
    public static let name = "format"

    public static func from(string: String) -> SerializationFormat?
    {
        switch string {
        case "json":
            return .json
        case "byteTree":
            return .byteTree
        default:
            return nil
        }
    }
}

extension SerializationFormat
{
    var treeFormat: SwiftLang.SyntaxTreeFormat<Data>
    {
        switch self {
        case .json:
            return SwiftLang.SyntaxTreeFormat<Data>.json
        case .byteTree:
            return SwiftLang.SyntaxTreeFormat<Data>.byteTree
        }
    }
}
