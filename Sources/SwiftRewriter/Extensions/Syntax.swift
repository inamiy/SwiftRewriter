import SwiftSyntax

extension Syntax
{
    /// `Syntax` is in `(line, column) == (1, 1)`.
    public var containsFirstToken: Bool
    {
        return self.position.line == 1 && self.position.column == 1
    }

    /// Find 1st descendant (excluding `self`).
    public func ancestor<T>(where f: (Syntax) -> T?) -> T?
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
    public func descendant<T>(where f: (Syntax) -> T?) -> T?
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

    // MARK: - Descendants in ascending / descending order

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

    /// Find `self` or `parent`'s next sibling's `TokenSyntax`.
    /// - Note: `self` and its descendants are not included.
    public var nextToken: TokenSyntax?
    {
        return self.nextTokens(stop: { _ in true }).first
    }

    /// Collect `self`'s or `parent`'s next sibling's `TokenSyntax`s.
    /// - Note: `self` and its descendants are not included.
    public func nextTokens(stop f: (TokenSyntax) -> Bool) -> [TokenSyntax]
    {
        guard let parent = self.parent else {
            return []
        }

        let siblings = parent.children.drop(while: { !($0 == self) }).dropFirst()
        var result = [TokenSyntax]()

        for sibling in siblings {
            let (tokens, stop) = sibling
                ._descendantsInAscending(where: { syntax -> (TokenSyntax?, Bool) in
                    if let token = syntax as? TokenSyntax {
                        return (token, f(token))
                    }
                    else {
                        return (nil, false)
                    }
                })

            result.append(contentsOf: tokens)

            if stop {
                return result
            }
        }

        result.append(contentsOf: parent.nextTokens(stop: f))
        return result
    }

    /// Find `self`'s or `parent`'s previous sibling's `TokenSyntax`.
    /// - Note: `self` and its descendants are not included.
    public var previousToken: TokenSyntax?
    {
        return self.previousTokens(stop: { _ in true }).first
    }

    /// Collect `self`'s or `parent`'s previous sibling's `TokenSyntax`s.
    ///
    /// For example, this is useful to collect current line's tokens until `self`:
    ///
    ///     let previousTokens = syntax.previousTokens(stop: {
    ///         return $0.leadingTriviaLength.newlines > 0
    ///     })
    ///
    /// - Note: `self` and its descendants are not included.
    public func previousTokens(stop f: (TokenSyntax) -> Bool) -> [TokenSyntax]
    {
        guard let parent = self.parent else {
            return []
        }

        let siblings = parent.children.prefix(while: { !($0 == self) }).reversed()
        var result = [TokenSyntax]()

        for sibling in siblings {
            let (tokens, stop) = sibling
                ._descendantsInDescending(where: { syntax -> (TokenSyntax?, Bool) in
                    if let token = syntax as? TokenSyntax {
                        return (token, f(token))
                    }
                    else {
                        return (nil, false)
                    }
                })

            result.insert(contentsOf: tokens, at: 0)

            if stop {
                return result
            }
        }

        result.insert(contentsOf: parent.previousTokens(stop: f), at: 0)
        return result
    }
}
