struct Foo {
let int: Int
init(int: Int) {
self.int = int
}
}

enum Foo {
case foo
init(int: Int) {
self = .foo
}
}

class Foo {
let int: Int
init(int: Int) {
self.int = int
}
}

extension Foo {
func hello() {}
}

protocol Foo {
func hello()
}
