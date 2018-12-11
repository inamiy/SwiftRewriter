import SwiftSyntax

/// Adjust indents for every list item e.g. func-param item, switch-case item, array item,
/// if 1st item is in the same line as previous token,
/// i.e. this indenter is aware of 1st item's position.
///
/// # Example
///
///     func foo(/* hello*/ x: Int,
///         ␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣y: Bool)
///
///     switch self {
///     case /* hello*/ .c1,
///         ␣␣␣␣␣␣␣␣␣␣␣␣.c2: break
///     }
///
/// - Precondition: Formatted by `CodeBlockIndenter`.
class FirstItemAwareIndenter: SyntaxRewriter
{
    override func visit(_ syntax: FunctionParameterListSyntax) -> Syntax
    {
        let syntax2 = self._adjustItemIndents(syntax)
        return super.visit(syntax2)
    }

    override func visit(_ syntax: FunctionCallArgumentListSyntax) -> Syntax
    {
        let syntax2 = self._adjustItemIndents(syntax)
        return super.visit(syntax2)
    }

    override func visit(_ syntax: CaseItemListSyntax) -> Syntax
    {
        let syntax2 = self._adjustItemIndents(syntax)
        return super.visit(syntax2)
    }

    override func visit(_ syntax: TuplePatternElementListSyntax) -> Syntax
    {
        let syntax2 = self._adjustItemIndents(syntax)
        return super.visit(syntax2)
    }

    override func visit(_ syntax: TupleTypeElementListSyntax) -> Syntax
    {
        let syntax2 = self._adjustItemIndents(syntax)
        return super.visit(syntax2)
    }

    override func visit(_ syntax: TupleElementListSyntax) -> Syntax
    {
        let syntax2 = self._adjustItemIndents(syntax)
        return super.visit(syntax2)
    }

    // MARK: - Tail-comment workarounds

    override func visit(_ syntax: ArrayExprSyntax) -> ExprSyntax
    {
        var syntax2 = syntax

        syntax2 = syntax2.withElements(self._adjustItemIndents(syntax.elements))

        let firstItemIndent = syntax.elements.positionAfterSkippingLeadingTrivia.column - 1

        // If array has tail comment before `]`, adjust comment's indent as well,
        // e.g. `[1,\n/* hello */]`, but not for `[1,\n/* hello */\n]` and `[1,\n234/* hello */\n]`.
        if syntax2.rightSquare.leadingTrivia.contains(where: { $0.isComment })
            && syntax2.rightSquare.leadingTrivia.first?.isNewline == true
            && !syntax2.rightSquare.leadingTrivia.isNewlineAtLastExceptSpaces
        {
            let indenter = FirstTokenRewriter {
                $0.withIndent(strategy: .forcedSpaces(spaces: firstItemIndent))
            }

            let rightSquare = indenter.visit(syntax2.rightSquare) as! TokenSyntax
            syntax2 = syntax2.withRightSquare(rightSquare)
        }

        return syntax2
    }

    override func visit(_ syntax: DictionaryExprSyntax) -> ExprSyntax
    {
        guard let content = syntax.content as? DictionaryElementListSyntax else {
            return super.visit(syntax)
        }

        var syntax2 = syntax

        syntax2 = syntax2.withContent(self._adjustItemIndents(content))

        let firstItemIndent = content.positionAfterSkippingLeadingTrivia.column - 1

        // If dictionary has tail comment before `]`, adjust comment's indent as well.
        if syntax2.rightSquare.leadingTrivia.contains(where: { $0.isComment })
            && syntax2.rightSquare.leadingTrivia.first?.isNewline == true
            && !syntax2.rightSquare.leadingTrivia.isNewlineAtLastExceptSpaces
        {
            let indenter = FirstTokenRewriter {
                $0.withIndent(strategy: .forcedSpaces(spaces: firstItemIndent))
            }

            let rightSquare = indenter.visit(syntax2.rightSquare) as! TokenSyntax
            syntax2 = syntax2.withRightSquare(rightSquare)
        }

        return syntax2
    }

    // MARK: - Private

    /// Adjust indents of item list based on 1st item's position.
    private func _adjustItemIndents<T>(_ syntax: T) -> T
        where T: SyntaxCollection, T.Element: Syntax
    {
        guard let firstItem = syntax.first,
            firstItem.leadingTriviaLength.newlines == 0 else
        {
            return syntax
        }

        let firstItemIndent = syntax.positionAfterSkippingLeadingTrivia.column - 1

        var syntax2 = syntax

        for (i, item) in syntax2.enumerated()
            where item.leadingTriviaLength.newlines > 0
        {
            if i == 0 { continue }

            let indenter = FirstTokenRewriter {
                $0.withIndent(strategy: .forcedSpaces(spaces: firstItemIndent))
            }

            let item2 = indenter.visit(item) as! T.Element
            syntax2 = syntax2.replacing(childAt: i, with: item2)
        }

        return syntax2
    }
}
