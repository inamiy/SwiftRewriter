import SwiftSyntax

extension Syntax
{
    /// `Syntax` is in `(line, column) == (1, 1)`.
    var containsFirstToken: Bool
    {
        return self.position.utf8Offset == 0
    }

    /// Number of lines excluding leading & trailing trivias.
    var numberOfContentLines: Int
    {
        var isFirstLeadingTrivia = true
        var lastTrailingTrivia = 0
        var total = 1

        for token in self.tokens {
            if isFirstLeadingTrivia {
                isFirstLeadingTrivia = false
            }
            else {
                total += token.leadingTrivia.numberOfNewlines
            }

            lastTrailingTrivia = token.trailingTrivia.numberOfNewlines
            total += lastTrailingTrivia
        }

        total -= lastTrailingTrivia

        return total
    }

    /// Find 1st descendant (excluding `self`).
    func ancestor<T>(where f: (Syntax) -> T?) -> T?
    {
        var current: Syntax = self
        while let parent = current.parent {
            if let parent = f(parent) {
                return parent
            }
            current = parent
        }

        return nil
    }

    /// Find 1st descendant (excluding `self`).
    func descendant<T>(where f: (Syntax) -> T?) -> T?
    {
        for child in self.children {
            if let child = f(child) {
                return child
            }
            else if let child = child.descendant(where: f) {
                return child
            }
        }

        return nil
    }

    /// Traverse in ascending order (including `self`).
    private func _descendantsInAscending<T>(where f: (Syntax) -> (T?, stop: Bool)) -> ([T], stop: Bool)
    {
        var result = [T]()

        let (value, stop) = f(self)

        if let value = value {
            result.append(value)

            if stop {
                return (result, true)
            }

            // NOTE: Won't traverse children if matched.
        }
        else {
            if stop {
                return (result, true)
            }

            for child in self.children {
                let (descendants, stop) = child._descendantsInAscending(where: f)
                result.append(contentsOf: descendants)

                if stop {
                    return (result, true)
                }
            }
        }

        return (result, false)
    }

    /// Traverse in descending order (including `self`).
    private func _descendantsInDescending<T>(where f: (Syntax) -> (T?, stop: Bool)) -> ([T], stop: Bool)
    {
        var result = [T]()

        let (value, stop) = f(self)

        if let value = value {
            result.insert(value, at: 0)

            if stop {
                return (result, true)
            }

            // NOTE: Won't traverse children if matched.
        }
        else {
            if stop {
                return (result, true)
            }

            for child in self.children.reversed() {
                let (descendants, stop) = child._descendantsInDescending(where: f)
                result.insert(contentsOf: descendants, at: 0)

                if stop {
                    return (result, true)
                }
            }
        }

        return (result, false)
    }

    var isLastChild: Bool
    {
        let parent = self.parent as? _SyntaxCollection
        return self.indexInParent == (parent?.count ?? 0) - 1
    }
}

extension SourceLocationConverter
{
    convenience init(tree: SourceFileSyntax)
    {
        // NOTE: `file` is not needed.
        self.init(file: "", tree: tree)
    }
}
