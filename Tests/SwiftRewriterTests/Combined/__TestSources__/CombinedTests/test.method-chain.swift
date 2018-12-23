indexPath = section.lazy
    .enumerated()
    .compactMap { (offset: Int, element: [SectionElement]) -> IndexPath? in
        let row = element.lazy
            .enumerated()
            .compactMap { (offset: Int, element: SectionElement) -> Int? in
                if element == .section1(.flag) {
                    return offset
                } else {
                    return nil
                }
            }.first
        return row.map { IndexPath(row: $0, section: offset) }
    }.first!
