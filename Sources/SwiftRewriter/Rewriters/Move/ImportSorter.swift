import SwiftSyntax

/// Sort `import` declarations.
open class ImportSorter: SyntaxRewriter
{
    private var _isFirstCodeBlockItemList = true

    open override func visit(_ syntax: CodeBlockItemListSyntax) -> Syntax
    {
        guard self._isFirstCodeBlockItemList else {
            return super.visit(syntax)
        }

        self._isFirstCodeBlockItemList = false

        let sortedItemTuples = syntax.children
            .map { ($0, $0.descendant { $0 as? ImportDeclSyntax }) }
            .sorted(by: {
                switch ($0.1, $1.1) {
                case let (l?, r?):
                    return "\(l.path)" < "\(r.path)"
                case (.none, _?):
                    return false
                case (_?, .none):
                    return true
                case (.none, .none):
                    return false
                }
            })

        let sortedItems = sortedItemTuples
            .map { $0.0 as! CodeBlockItemSyntax }

        let importCount = sortedItemTuples.lazy.filter { $0.1 != nil }.count

        var newItemList = SyntaxFactory.makeBlankCodeBlockItemList()

        var previousHasTrailingNewline = true

        for (i, item) in sortedItems.enumerated() {

            let isFirstNonImport = (importCount > 0 && i == importCount)

            /// When `isFirstNonImport`, try inserting leading newline so that
            /// last `ImportDecl` will not be attached to next `item`.
            let postprocess: (TokenSyntax) -> TokenSyntax = { token in
                guard isFirstNonImport && !token.leadingTrivia.isNewlineAtFirstExceptSpaces else {
                    return token
                }

                var leadingTrivia = token.leadingTrivia
                leadingTrivia = leadingTrivia.inserting(.newlines(1), at: 0)
                return token.withLeadingTrivia(leadingTrivia)
            }

            let newItem: CodeBlockItemSyntax

            // Remove redundant `leadingTrivia`'s first empty lines.
            if i == 0 {
                let trimmer = FirstTokenRewriter(
                    rewrite: { $0.withoutLeadingTriviaFirstEmptyLines() }
                        >>> postprocess
                )

                newItem = trimmer.visit(item) as! CodeBlockItemSyntax
            }
            // Insert newline if needed.
            else if i < importCount
                && !previousHasTrailingNewline
                && item.leadingTrivia?.isNewlineAtFirstExceptSpaces != true
            {
                let inserter = FirstTokenRewriter(
                    rewrite: { $0.withLeadingTrivia(.newlines(1) + $0.leadingTrivia) }
                        >>> postprocess
                )

                newItem = inserter.visit(item) as! CodeBlockItemSyntax
            }
            else {
                let inserter = FirstTokenRewriter(
                    rewrite: postprocess
                )

                newItem = inserter.visit(item) as! CodeBlockItemSyntax
            }

            newItemList = newItemList.appending(newItem)

            previousHasTrailingNewline = item.trailingTriviaLength.newlines > 0
        }

        return super.visit(newItemList)
    }

}
