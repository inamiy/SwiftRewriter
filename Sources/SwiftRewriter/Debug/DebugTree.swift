import SwiftSyntax

/// Handy representation for debugging.
public struct DebugTree: CustomStringConvertible
{
    let syntaxType: Syntax.Type
    let tokenTexts: [String]
    let tokenKind: TokenKind?
    let info: [String]
    let children: [DebugTree]
    let indent: Int

    public init(_ syntax: Syntax)
    {
        self.init(syntax, indent: 0)
    }

    private init(_ syntax: Syntax, indent: Int)
    {
        self.syntaxType = type(of: syntax)

        self.info = [
//            "L = \(syntax.leadingTrivia?.pieces ?? [])",
//            "T = \(syntax.trailingTrivia?.pieces ?? [])",
            "ContentLength = \(syntax.contentLength)"
            ]

        self.children = syntax.children
            .map { DebugTree($0, indent: indent + 1) }

        self.indent = indent

        if let tokenSyntax = syntax as? TokenSyntax {
            self.tokenTexts = [tokenSyntax.text]
            self.tokenKind = tokenSyntax.tokenKind
        }
        else {
            self.tokenTexts = self.children
                .flatMap { $0.tokenTexts }
            self.tokenKind = nil
        }
    }

    public var description: String
    {
        let children = self.children
            .map { $0.description }
            .joined(separator: "\n")

        let info = self.info
            .enumerated()
            .map { indentStr(indent + 1) + "[\($0)] => " + $1.description }
            .joined(separator: "\n")

        return """
        \(indentStr(indent))=== \(syntaxType) === {
        \(indentStr(indent + 1))tokens: \(tokenTexts), tokenKind: \(desc(tokenKind))
        \(info)

        \(children)
        \(indentStr(indent))}
        """
    }
}

// MARK: - Private

private func indentStr(_ count: Int) -> String
{
    return String(repeating: " ", count: 2 * count)
}

private func desc(_ x: Any?) -> String
{
    guard let x = x else { return "(none)" }
    return "\(x)"
}
