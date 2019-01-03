import SwiftSyntax

/// SwiftSyntax bug-fix rewriter.
///
/// # Fixed-bug:
/// - `[TokenSyntax("{"), UnknownSyntax(declList), TokenSyntax("}")]`
///
/// # Unfixed-bug:
/// - Nested `if #DEBUG ... #endif`
/// - `if #available(iOS 10.0, *) {}`
open class BugFixer: SyntaxRewriter
{
    open override func visit(_ syntax: StructDeclSyntax) -> DeclSyntax
    {
        return super.visit(self._fixStructMemberUnknownSyntaxBug(syntax))
    }

    open override func visit(_ syntax: EnumDeclSyntax) -> DeclSyntax
    {
        return super.visit(self._fixStructMemberUnknownSyntaxBug(syntax))
    }

    open override func visit(_ syntax: ClassDeclSyntax) -> DeclSyntax
    {
        return super.visit(self._fixStructMemberUnknownSyntaxBug(syntax))
    }

    open override func visit(_ syntax: ExtensionDeclSyntax) -> DeclSyntax
    {
        return super.visit(self._fixStructMemberUnknownSyntaxBug(syntax))
    }

    open override func visit(_ syntax: ProtocolDeclSyntax) -> DeclSyntax
    {
        return super.visit(self._fixStructMemberUnknownSyntaxBug(syntax))
    }

    /// Bugfix for `[TokenSyntax("{"), UnknownSyntax(declList), TokenSyntax("}")]`.
    private func _fixStructMemberUnknownSyntaxBug<T: DeclGroupSyntax>(_ syntax: T) -> T
    {
        var struct_ = syntax

        // Workaround:
        // Due to SwiftSyntax bug, `children` have
        /// `[TokenSyntax("{"), UnknownSyntax(declList), TokenSyntax("}")]`,
        // so replace `UnknownSyntax` with `MemberDeclList`.
        if let unknownDeclList = struct_.members.children.first(where: { $0 is UnknownSyntax }) {
            let declListItems = unknownDeclList.children
                .compactMap { syntax_ -> MemberDeclListItemSyntax? in
                    guard let decl = syntax_ as? DeclSyntax else { return nil }

                    if let unknownDecl = decl as? UnknownDeclSyntax {
                        // Try extracting `UnknownDeclSyntax`.
                        switch (unknownDecl.child(at: 0), unknownDecl.child(at: 1)) {
                        case let (child0 as DeclSyntax, .none):
                            return MemberDeclListItemSyntax {
                                $0.useDecl(child0)
                            }
                        case let (child0 as DeclSyntax, child1 as TokenSyntax) where child1.tokenKind == .semicolon:
                            return MemberDeclListItemSyntax {
                                $0.useDecl(child0)
                                $0.useSemicolon(child1)
                            }
                        default:
                            // Give up unwrapping `UnknownDeclSyntax`.
                            return MemberDeclListItemSyntax {
                                $0.useDecl(unknownDecl)
                            }
                        }
                    }
                    else {
                        return MemberDeclListItemSyntax {
                            $0.useDecl(decl)
                        }
                    }
                }

            let declList2 = SyntaxFactory.makeMemberDeclList(declListItems)
            let newMembers = struct_.members.withMembers(declList2)
            struct_ = struct_.withMembers(newMembers)
        }

        return struct_
    }

    // MARK: - Nested `#if DEBUG ... #endif` (UnknownDeclSyntax bug)

//    open override func visit(_ syntax: UnknownDeclSyntax) -> DeclSyntax
//    {
//    }

    // MARK: - `if #available(iOS 10.0, *)` (UnknownStmtSyntax bug)

//    open override func visit(_ syntax: UnknownStmtSyntax) -> StmtSyntax
//    {
//    }
}
