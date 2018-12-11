import SwiftSyntax

/// Move `struct + init` code to `extension + init`
/// for enabling memberwise initializer.
open class ExtensionIniter: SyntaxRewriter
{
    open override func visit(_ syntax: SourceFileSyntax) -> Syntax
    {
        let remover = _StructInitRemover()
        let syntax2 = remover.visit(syntax) as! SourceFileSyntax

        var itemList = syntax2.statements

        let removedInits = Array(remover.removedInits)
            .sorted(by: { $0.key < $1.key })
            .map { ($1.0, $1.1) }

        for (struct_, inits) in removedInits {

            let newItem = SyntaxFactory.makeCodeBlockItem(
                item: SyntaxFactory.makeExtensionDecl(
                    attributes: nil,
                    modifiers: nil,
                    extensionKeyword: SyntaxFactory.makeExtensionKeyword(
                        leadingTrivia: [.newlines(2)],
                        trailingTrivia: [.spaces(1)]
                    ),
                    extendedType: struct_,
                    inheritanceClause: nil,
                    genericWhereClause: nil,
                    members: MemberDeclBlockSyntax.init({ builder in
                        builder.useLeftBrace(SyntaxFactory.makeLeftBraceToken(leadingTrivia: [.spaces(1)]))
                        for init_ in inits {
                            builder.addMemberDeclListItem(MemberDeclListItemSyntax.init { b in
                                b.useDecl(init_)
                            })
                        }
                        builder.useRightBrace(SyntaxFactory.makeRightBraceToken(leadingTrivia: [.newlines(1)]))
                    })),
                semicolon: nil,
                errorTokens: nil
            )

            itemList = itemList.appending(newItem)

        }

        return super.visit(syntax2.withStatements(itemList))

    }

}

// MARK: - Private

private class _StructInitRemover: SyntaxRewriter
{
    var removedInits: [String: (TypeSyntax, [InitializerDeclSyntax])] = [:]

    open override func visit(_ syntax: StructDeclSyntax) -> DeclSyntax
    {
        let structFullIdentifier = syntax.fullIdentifier

        var declList = syntax.members.members
        var removedInits_: [InitializerDeclSyntax] = []

        // Remove `InitializerDeclSyntax`s from struct.
        for (i, item) in syntax.members.members.enumerated().reversed() {
            let decl = item.decl

            if let decl = decl as? InitializerDeclSyntax {
                removedInits_.insert(decl, at: 0)
                declList = declList.removing(childAt: i)
            }
        }

        self.removedInits[structFullIdentifier.description] = (structFullIdentifier, removedInits_)

        let newMembers = syntax.members.withMembers(declList)
        let syntax2 = syntax.withMembers(newMembers)

        return super.visit(syntax2)
    }

}
