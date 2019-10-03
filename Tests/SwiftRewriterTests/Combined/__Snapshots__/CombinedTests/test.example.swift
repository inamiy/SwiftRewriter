import A
import B
/// should keep

import C
import D
import X
import Y

import Z

func hoge() {}

/**
 * doc
 */
public func hello() {}

let x = 1 // comment

xxxxx
    = 1 + 2

let x
    = 1 + 2

1
    + 2

aaa
    .b
    .c

aaa
    .b
    .c()

aaa
    .b()
    .c

aaa
    .b()
    .c()

apiSession
    .send {
        $0.run {
            $0
        }
    }
    .send

apiSession
    .send
    .send {
        $0.run {
            $0
        }
    }

api.send {
    run {
        $0
    }
    $0.run {
        $0
    }
}
    .foo()
    .bar()
    .foo {
        print()
        $0.run {
            print()
        }
        print()
    }
    .hoge {
        print()
    }

public func allTests() -> [XCTestCaseEntry] {
    return [
        x,
        y
    ]
}

public func allTests() -> [XCTestCaseEntry: Int] {
    return [
        x: 1,
        y: 2
    ]
}

public func naturalTransform<NT: NaturalTransformation>(_ transformation: NT.Type) -> Kind<NT.G, A1>
    where NT.F == F
{
    return NT.naturalTransform(self)
}

public func naturalTransform<NT: NaturalTransformation>(_ transformation: NT.Type) -> Kind<NT.G, A1> where
    NT.F == F,
    X == Y
{
    return NT.naturalTransform(self)
}

#if DEBUG

// TODO
/// foo bar
open var path: UIBezierPath?
{
    /*fsadfdsafsadfdsafsadf*/get {
        return self.layer.path.map(UIBezierPath.init)
    }
    set {
        self.layer.path = newValue?.cgPath
    }
}

#endif

public indirect enum List<Element>
{
    case `nil`
    case cons(Element, List<Element>)
}

apiSession   // test1
    .send()   // test2
    .subscribe()   // test3
