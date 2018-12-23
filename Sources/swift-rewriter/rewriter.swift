import SwiftRewriter

/// Global rewriter.
var rewriter: Rewriter {
    return
        // Workaround for SwiftSyntax bug (required)
        BugFixer()

        // Comment
        >>> HeaderCopyrightTrimmer()

        // Move
        >>> ImportSorter()
//        >>> ExtensionIniter() // not useful for everyone

        // Newline
//        >>> ExtraNewliner()   // not useful for everyone
        >>> ElseNewliner(newline: false)
        >>> MethodChainNewliner()

        // Indent
        >>> Indenter(.init(
            perIndent: .spaces(4),
            shouldIndentSwitchCase: false,
            shouldIndentIfConfig: false,
            skipsCommentedLine: true,
            usesXcodeStyle: true
            ))

        // Space
//        >>> ExtraSpaceTrimmer()   // may disturb manually-aligned code

        >>> ColonSpacer(spaceBefore: false, spaceAfter: true)
        >>> TernaryExprSpacer()
        >>> BinaryOperatorSpacer(spacesAround: true)

        // Ignore to not distrub user-aligned multiple assignments
        // TODO: Improve multiple assignment alignment
//        >>> EqualSpacer(spacesAround: true)

        >>> ArrowSpacer(spaceBefore: true, spaceAfter: true)
        >>> LeftBraceSpacer(spaceBefore: true)
        >>> LeftParenSpacer(spaceBefore: true)
        >>> TrailingSpaceTrimmer()
}
