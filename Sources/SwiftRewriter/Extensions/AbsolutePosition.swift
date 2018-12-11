import SwiftSyntax

extension AbsolutePosition: Equatable
{
    public static func == (l: AbsolutePosition, r: AbsolutePosition) -> Bool
    {
        return l.column == r.column && l.line == r.line && l.utf8Offset == r.utf8Offset
    }
}
