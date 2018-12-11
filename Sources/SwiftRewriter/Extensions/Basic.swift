extension MutableCollection where Index: Strideable
{
    mutating func updateLast(_ element: Element)
    {
        guard !self.isEmpty else { return }

        let lastIndex = self.endIndex.advanced(by: -1)
        self[lastIndex] = element
    }

    func updatingLast(_ element: Element) -> Self
    {
        guard !self.isEmpty else { return self }

        var copy = self
        copy.updateLast(element)
        return copy
    }
}
