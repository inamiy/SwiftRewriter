/// Left-to-right function composition.
func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C
{
    return { g(f($0)) }
}
