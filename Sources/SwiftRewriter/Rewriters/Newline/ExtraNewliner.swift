import SwiftSyntax

/// Insert an extra newline to condensed code.
open class ExtraNewliner: SyntaxRewriter
{
    open override func visit(_ syntax: CodeBlockItemListSyntax) -> Syntax
    {
        return super.visit(self._visitChildren(syntax))
    }

    open override func visit(_ syntax: MemberDeclListSyntax) -> Syntax
    {
        return super.visit(self._visitChildren(syntax))
    }

    private func _visitChildren<T>(_ syntax: T) -> T
        where T: SyntaxCollection, T.Element: Syntax
    {
        let isFirstLine = syntax.containsFirstToken

        // Skip inserting newline if `syntax` only has 1 or 2 lines (less than 2 "\n"s).
        guard isFirstLine || syntax.contentLength.newlines >= 2 else {
            return syntax
        }

        /// Array of newline flags that is determined by comparing two `T.Element`s.
        let shouldInsertNewlineArray = zip(syntax, syntax.dropFirst())
            .map { tuple -> Bool in
                let child1 = tuple.0
                let child2 = tuple.1

                func firstChildType(_ syntax: Syntax) -> Syntax.Type?
                {
                    return syntax.child(at: 0).map { type(of: $0) }
                }

                if child1.trailingTrivia?.hasEmptyNewline == true
                    || child2.leadingTrivia?.hasEmptyNewline == true
                    // Let newline NOT be inserted when 2 consecutive `T.Element`s have
                    // same child type (e.g. `GuardStmtSyntax`)
                    // and both `newlines` are 1 or less (= comments are probably not included).
                    || (child1.trailingTriviaLength.newlines <= 1
                        && child2.leadingTriviaLength.newlines <= 1
                        && firstChildType(child1) == firstChildType(child2))
                {
                    return false
                }
                else {
                    return true
                }
            }

        var syntax2 = syntax

        // Insert newlines in reverse order.
        for (i, shouldInsertNewline) in shouldInsertNewlineArray.enumerated().reversed()
            where shouldInsertNewline
        {
            let rewriter = FirstTokenRewriter {
                $0.withoutLeadingTriviaFirstEmptyLines(replacingTo: [.newlines(2)])
            }

            let child = syntax.child(at: i + 1) as! T.Element

            syntax2 = syntax2.replacing(childAt: i + 1, with: rewriter.visit(child) as! T.Element)
        }

        return syntax2
    }

}
