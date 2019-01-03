import SwiftSyntax

/// Trim `";"`s that appear at the last token of the line.
open class SemicolonTrimmer: SyntaxRewriter, HasRewriterExamples
{
    var rewriterExamples: [String: String]
    {
        return [
            "x = 1;": "x = 1",
            "x = 1; y = 2;": "x = 1; y = 2",

            // NOTE: semicolon's trailing space will also be deleted.
            "struct Foo { let x = 1; }": "struct Foo { let x = 1}",
            "struct Foo { let x = 1; let y = 2; }": "struct Foo { let x = 1; let y = 2}"
        ]
    }

    var rewriterNoChangeExamples: [String]
    {
        return [
            "x = 1; y = 2",
            "struct Foo { let x = 1 }",
            "struct Foo { let x = 1; let y = 2 }"
        ]
    }

    open override func visit(_ syntax: CodeBlockItemSyntax) -> Syntax
    {
        if let nextToken = syntax.nextToken,
            nextToken.leadingTrivia.contains(where: { $0.isNewline }) || syntax.isLastChild
        {
            return super.visit(syntax.withSemicolon(nil))
        }
        else {
            return super.visit(syntax)
        }
    }

    open override func visit(_ syntax: MemberDeclListItemSyntax) -> Syntax
    {
        if let nextToken = syntax.nextToken,
            nextToken.leadingTrivia.contains(where: { $0.isNewline }) || syntax.isLastChild
        {
            return super.visit(syntax.withSemicolon(nil))
        }
        else {
            return super.visit(syntax)
        }
    }
}
