import XCTest
@testable import SwiftRewriter

final class BlockItemIndenterTests: XCTestCase
{
    /// - Note: Uses random value to reduce test duration.
    func test_examples() throws
    {
        let perIndent = [PerIndent.spaces(4), .tabs(1)].randomElement()!
        let usesXcodeStyle = Bool.random()

        try runExamples(using: BlockItemIndenter(
            perIndent: perIndent,
            usesXcodeStyle: usesXcodeStyle
        ))
    }

    func test_do() throws
    {
        let source = """
            do {
            return
            }
            """

        let expected = """
            do {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_if1() throws
    {
        let source = """
            if let x = x, let y = y {
            return
            }
            """

        let expected = """
            if let x = x, let y = y {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_if2() throws
    {
        let source = """
            if let x = x,
            let y = y {
            return
            }
            """

        let expected = """
            if let x = x,
                let y = y {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_if3() throws
    {
        let source = """
            if let x = x,
            let y = y {
            return
            }
            """

        let expected = """
            if let x = x,
                let y = y {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_if4() throws
    {
        let source = """
            if let error = error,
            error.isTimeout || error.isUnavailable {
            print()
            }
            """

        let expected = """
            if let error = error,
                error.isTimeout || error.isUnavailable {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_if5() throws
    {
        let source = """
            if let error = error,
                error.isTimeout
                    || error.isUnavailable {
                print()
            }
            """

        let expected = """
            if let error = error,
                error.isTimeout
                    || error.isUnavailable {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_guard1() throws
    {
        let source = """
            guard true, true else {
            return
            }
            """

        let expected = """
            guard true, true else {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_guard2() throws
    {
        let source = """
            guard true,
            true else {
            return
            }
            """

        let expected = """
            guard true,
                true else {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_guard3() throws
    {
        let source = """
            guard true,
            true
            else {
            return
            }
            """

        let expected = """
            guard true,
                true
                else {
                    return
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_tree() throws
    {
        let source = """
            let tree: Tree<Int> =
            .node(
            .node(.leaf, 1, .leaf),
            2,
            .node(.leaf, 3, .leaf)
            )
            """

        let expected = """
            let tree: Tree<Int> =
                .node(
                    .node(.leaf, 1, .leaf),
                    2,
                    .node(.leaf, 3, .leaf)
                )
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_sequenceExpr() throws
    {
        let source = """
            property("`alpha . F f = G f . alpha` holds") <- forAll { (strings: [String]) in
            return (strings.kind |> nat_Ff).value == (strings.kind |> Gf_nat).value
            }
            """

        let expected = """
            property("`alpha . F f = G f . alpha` holds") <- forAll { (strings: [String]) in
                return (strings.kind |> nat_Ff).value == (strings.kind |> Gf_nat).value
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_inheritedTypeList() throws
    {
        let source = """
            struct Foo: A, B, C,
            D, E, F {
            }
            """

        let expected = """
            struct Foo: A, B, C,
                D, E, F {
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    // NOTE: `FirstItemAwareIndenter` handles better indent.
    func test_tuplePatternElementList() throws
    {
        let source = """
            let (a,
            b,
            c) = x
            """

        let expected = """
            let (a,
                b,
                c) = x
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    // NOTE: `FirstItemAwareIndenter` handles better indent.
    func test_tupleTypeElementList() throws
    {
        let source = """
            func foo() -> (a: A,
            b: B,
            c: C) {
            }
            """

        let expected = """
            func foo() -> (a: A,
                b: B,
                c: C) {
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    // NOTE: `FirstItemAwareIndenter` handles better indent.
    func test_tupleElementList() throws
    {
        let source = """
            return (left: 0,
            right: 0)
            """

        let expected = """
            return (left: 0,
                right: 0)
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// `init...\nwhere T: U`
    func test_init_whereClause1() throws
    {
        let source = """
            init(
            x: Int,
            y: Int)
            where T: T1,
            U == U1 {
            print()
            }
            """

        let expected = """
            init(
                x: Int,
                y: Int)
                where T: T1,
                    U == U1 {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// `init...where\nT: U`
    func test_init_whereClause2() throws
    {
        let source = """
            init(
            x: Int,
            y: Int) where
            T: T1,
            U == U1 {
            print()
            }
            """

        let expected = """
            init(
                x: Int,
                y: Int) where
                T: T1,
                U == U1 {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// `init(...\n) where T: U` (NOTE: Needs `FuncSignatureSyntax` or parent)
    func test_init_whereClause3() throws
    {
        let source = """
            init(
            x: Int,
            y: Int
            ) where
            T: T1,
            U == U1 {
            print()
            }
            """

        let expected = """
            init(
                x: Int,
                y: Int
                ) where
                    T: T1,
                    U == U1 {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_func_leftParenNewline() throws
    {
        let source = """
            func foo
            ()
            -> Int {}
            """

        let expected = """
            func foo
                ()
                -> Int {}
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_func_rightParenNewline() throws
    {
        let source = """
            struct Foo {
            func foo   (
            aaa: Int,
            bb: Int
                                       ) {}
                    }
            """

        let expected = """
            struct Foo {
                func foo   (
                    aaa: Int,
                    bb: Int
                    ) {}
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// `func ...\nwhere T: U`
    func test_func_whereClause1() throws
    {
        let source = """
            func foo<T, U>() -> Int
            where T: T1,
            U == U1
            {
            print()
            }
            """

        let expected = """
            func foo<T, U>() -> Int
                where T: T1,
                    U == U1
            {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// `func ...where\nT: U`
    func test_func_whereClause2() throws
    {
        let source = """
            func foo<T, U>() -> Int where
            T: T1,
            U == U1
            {
            print()
            }
            """

        let expected = """
            func foo<T, U>() -> Int where
                T: T1,
                U == U1
            {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// `func ...\n) where T: U` (NOTE: Needs `FuncSignatureSyntax` or parent)
    func test_func_whereClause3() throws
    {
        let source = """
            func foo<T, U>(
            x: Int
            ) where
            T: T1,
            U == U1 {
            print()
            }
            """

        let expected = """
            func foo<T, U>(
                x: Int
                ) where
                T: T1,
                U == U1 {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_func_newlineReturnType1() throws
    {
        let source = """
            func foo(
            x: Int,
            y: Int)
            -> Int {}
            """

        let expected = """
            func foo(
                x: Int,
                y: Int)
                -> Int {}
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_func_newlineReturnType2() throws
    {
        let source = """
            func foo(
            x: Int,
            y: Int
            ) -> Int {
            print()
            }
            """

        let expected = """
            func foo(
                x: Int,
                y: Int
            ) -> Int {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: false)
        )
    }

    func test_func_newlineReturnType2_usesXcodeStyle() throws
    {
        let source = """
            func foo(
            x: Int,
            y: Int
            ) -> Int {
            print()
            }
            """

        let expected = """
            func foo(
                x: Int,
                y: Int
                ) -> Int {
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: true)
        )
    }

    func test_property() throws
    {
        let source = """
            var path: UIBezierPath? {
            /*fsadfdsafsadfdsafsadf*/ get {
            return self.layer.path.map(UIBezierPath.init)
            }
            set {
            self.layer.path = newValue?.cgPath
            }
            }
            """

        let expected = """
            var path: UIBezierPath? {
                /*fsadfdsafsadfdsafsadf*/ get {
                    return self.layer.path.map(UIBezierPath.init)
                }
                set {
                    self.layer.path = newValue?.cgPath
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_ternaryExpr1() throws
    {
        let source = """
            flag
            ? true
            : false
            """

        let expected = """
            flag
                ? true
                : false
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_ternaryExpr2() throws
    {
        let source = """
            func foo() {
            let flag = state == .ok
            ? true
            : false
            print()
            }
            """

        let expected = """
            func foo() {
                let flag = state == .ok
                    ? true
                    : false
                print()
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_multipleBinding() throws
    {
        let source = """
            let x,
            y: Int
            """

        let expected = """
            let x,
                y: Int
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// Inner CodeBlockItemList + ExprList
    func test_nestedListExpr1() throws
    {
        let source = """
            init(x: Int) {
            self.x = x
            self.y = y
            }
            """

        let expected = """
            init(x: Int) {
                self.x = x
                self.y = y
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// CodeBlockItemList + ParameterBindingList
    func test_nestedListExpr2() throws
    {
        let source = """
            let a = 1
                        let b = 2
                    let c = 3
            """

        let expected = """
            let a = 1
            let b = 2
            let c = 3
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// ConditionElementList + ignore inner ExprList
    func test_ignoreInnerList() throws
    {
        let source = """
            if true,
            true == true,
            false == false {
            return
            }
            """

        let expected = """
            if true,
                true == true,
                false == false {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_precedenceGroupAttributeList() throws
    {
        let source = """
            precedencegroup TransitionPrecedence {
            associativity: left
            higherThan: AdditionPrecedence
            }
            """

        let expected = """
            precedencegroup TransitionPrecedence {
                associativity: left
                higherThan: AdditionPrecedence
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    // MARK: - Method Chaining

    func test_methodChaining1() throws
    {
        let source = """
            a
            .b
            .c
            """

        let expected = """
            a
                .b
                .c
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// - Note: Better than Xcode 10.
    func test_methodChaining2() throws
    {
        let source = """
            a
            .b
            .c {
                return
            }
            """

        let expected = """
            a
                .b
                .c {
                    return
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining3() throws
    {
        let source = """
            a
            .b {
            return
            }
            .c
            """

        let expected = """
            a
                .b {
                    return
                }
                .c
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining4() throws
    {
        let source = """
            a
            .b {
            return
            }
            .c {
            return
            }
            """

        let expected = """
            a
                .b {
                    return
                }
                .c {
                    return
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    /// - Note: Better than Xcode 10.
    func test_methodChaining5() throws
    {
        let source = """
            a.b {
            return
            }.c {
            return
            }
            """

        let expected = """
            a.b {
                return
            }.c {
                return
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: false)
        )
    }

    func test_methodChaining5_usesXcodeStyle() throws
    {
        let source = """
            a.b {
            return
            }.c {
            return
            }
            """

        let expected = """
            a.b {
                return
                }.c {
                    return
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: true)
        )
    }

    func test_methodChaining6() throws
    {
        let source = """
                  let x =
              apiSession
            .send()
                .subscribe()
            """

        let expected = """
            let x =
                apiSession
                    .send()
                    .subscribe()
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining7() throws
    {
        let source = """
                  let x
              = apiSession
            .send()
                .subscribe()
            """

        let expected = """
            let x
                = apiSession
                    .send()
                    .subscribe()
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining8() throws
    {
        let source = """
            array
            .lazy.flatMap { a -> [Int] in
            return []
            }
            """

        let expected = """
            array
                .lazy.flatMap { a -> [Int] in
                    return []
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining_nested1() throws
    {
        let source = """
            return foo()
            .map {
            return bar
            .baz
            }
            """

        let expected = """
            return foo()
                .map {
                    return bar
                        .baz
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining_nested2() throws
    {
        let source = """
            return foo()
            .map {
            return bar
            .baz {
            print()
            }
            }
            """

        let expected = """
            return foo()
                .map {
                    return bar
                        .baz {
                            print()
                        }
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining_arg1() throws
    {
        let source = """
            apiSession
            .send(
            1,
            2
            ) {
            print()
            }
            """

        let expected = """
            apiSession
                .send(
                    1,
                    2
                ) {
                    print()
                }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining_arg2() throws
    {
        let source = """
            Observable.merge(
            o1,
            o2
            )
            .subscribe()
            """

        let expected = """
            Observable.merge(
                o1,
                o2
            )
                .subscribe()
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: false)
        )
    }

    func test_methodChaining_arg2_usesXcodeStyle() throws
    {
        let source = """
            Observable.merge(
            o1,
            o2
            )
            .subscribe()
            """

        let expected = """
            Observable.merge(
                o1,
                o2
            ␣␣␣␣)
                .subscribe()
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: true)
        )
    }

    func test_methodChaining_comment1() throws
    {
        let source = """
                apiSession   // test1
            .send()   // test2
                .subscribe()   // test3
            """

        let expected = """
            apiSession   // test1
                .send()   // test2
                .subscribe()   // test3
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining_comment2() throws
    {
        let source = """
                  let x =   // test1
                apiSession   // test2
            .send()   // test3
                .subscribe()   // test4
            """

        let expected = """
            let x =   // test1
                apiSession   // test2
                    .send()   // test3
                    .subscribe()   // test4
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining_comment3() throws
    {
        let source = """
                  let x   // test1
              = apiSession   // test2
            .send()   // test3
                .subscribe()   // test4
            """

        let expected = """
            let x   // test1
                = apiSession   // test2
                    .send()   // test3
                    .subscribe()   // test4
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_methodChaining_complex() throws
    {
        let source = """
            api.send {
            run {
            $0
            }
            $0.run {
            $0
            }
            }.foo()
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
            """

        let expected = """
            api.send {
                run {
                    $0
                }
                $0.run {
                    $0
                }
            }.foo()
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
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: false)
        )
    }

    func test_methodChaining_complex_usesXcodeStyle() throws
    {
        let source = """
            api.send {
            run {
            $0
            }
            $0.run {
            $0
            }
            }.foo()
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
            """

        let expected = """
            api.send {
                run {
                    $0
                }
                $0.run {
                    $0
                }
            ␣␣␣␣}.foo()
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
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(usesXcodeStyle: true)
        )
    }

    // MARK: -

    /// - Note: Func-params (without 1st item linebreak) will be indented by `FirstItemAwareIndenter`.
    func test_funcArg() throws
    {
        let source = """
                struct Foo {
                         init(   bool: Bool   ,
              int: Int   ) {
                              self.bool = bool
                           if true {
                     print()
                  }

                   run { x in
                            print(x,
                                      y,
                                          z)
                }
                        }
            }
            """

        let expected = """
            struct Foo {
                init(   bool: Bool   ,
                    int: Int   ) {
                    self.bool = bool
                    if true {
                        print()
                    }

                    run { x in
                        print(x,
                            y,
                            z)
                    }
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    // MARK: -

    // MARK: shouldIndentSwitchCase

    /// - Note: `case` multiline (without 1st item linebreak) will be indented by `FirstItemAwareIndenter`.
    func test_switch() throws
    {
        let source = """
            public class Foo {
            func foo(x: Int, y: Int, z: Int) {
            switch x {
            case .c0:
            break
            case /* hello */ .c1,
            .c2:
            print(y)
            print(z)
            default:
            print(y)
            print(z)
            }
            }
            }
            """

        let expected = """
            public class Foo {
                func foo(x: Int, y: Int, z: Int) {
                    switch x {
                    case .c0:
                        break
                    case /* hello */ .c1,
                        .c2:
                        print(y)
                        print(z)
                    default:
                        print(y)
                        print(z)
                    }
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentSwitchCase: false)
        )
    }

    /// - Note: `case` multiline (without 1st item linebreak) will be indented by `FirstItemAwareIndenter`.
    func test_switch_indented() throws
    {
        let source = """
            public class Foo {
            func foo(x: Int, y: Int, z: Int) {
            switch x {
            case .c0:
            break
            case /* hello */ .c1,
            .c2:
            print(y)
            print(z)
            default:
            print(y)
            print(z)
            }
            }
            }
            """

        let expected = """
            public class Foo {
                func foo(x: Int, y: Int, z: Int) {
                    switch x {
                        case .c0:
                            break
                        case /* hello */ .c1,
                            .c2:
                            print(y)
                            print(z)
                        default:
                            print(y)
                            print(z)
                    }
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentSwitchCase: true)
        )
    }

    func test_switch_where() throws
    {
        let source = """
            do {
            switch x {
            case .c0
            where t == 1:
            break
            }
            }
            """

        let expected = """
            do {
                switch x {
                case .c0
                    where t == 1:
                    break
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentSwitchCase: false)
        )
    }

    // MARK: shouldIndentIfConfig

    func test_ifConfigDecl_noIndent1() throws
    {
        let source = """
            #if DEBUG
                        return true
            #else
                    return false
            #endif
            """

        let expected = """
            #if DEBUG
            return true
            #else
            return false
            #endif
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentIfConfig: false)
        )
    }

    func test_ifConfigDecl_noIndent2() throws
    {
        let source = """
            do {
            #if TEST
            return ""
            #else
            return ""
            #endif
            }
            """

        let expected = """
            do {
                #if TEST
                return ""
                #else
                return ""
                #endif
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentIfConfig: false)
        )
    }

    func test_ifConfigDecl_noIndent3() throws
    {
        let source = """
            #if DEBUG
            run {
            print()
            }
            #endif
            """

        let expected = """
            #if DEBUG
            run {
                print()
            }
            #endif
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentIfConfig: false)
        )
    }

    func test_ifConfigDecl_noIndent4() throws
    {
        let source = """
                    #if os(iOS) || os(tvOS)
                           /// doc
                      struct Foo {
                 let foo: Bool
              #if DEBUG
                            let debug: Bool
                                func debug() {}
             #else
              let release: Bool
               func release() {}
                            #endif
                                    func foo() {}
                      }
                #else
            // hello
                    #endif
            """

        let expected = """
            #if os(iOS) || os(tvOS)
            /// doc
            struct Foo {
                let foo: Bool
                #if DEBUG
                let debug: Bool
                func debug() {}
                #else
                let release: Bool
                func release() {}
                #endif
                func foo() {}
            }
            #else
            // hello
            #endif
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentIfConfig: false)
        )
    }

    /// - Todo: Inner `#if` is deteced as `UnknownDecl` that is SwiftSyntax's bug.
    func test_ifConfigDecl_indent() throws
    {
        let source = """
                    #if os(iOS) || os(tvOS)
                           /// doc
                      struct Foo {
                 let foo: Bool
              #if DEBUG
                            let debug: Bool
                                func debug() {}
             #else
              let release: Bool
               func release() {}
                            #endif
                                    func foo() {}
                      }
                #else
            struct Foo {}
                    #endif
            """

        let expected = """
            #if os(iOS) || os(tvOS)
                /// doc
                struct Foo {
                    let foo: Bool
                    #if DEBUG
                        let debug: Bool
                        func debug() {}
                    #else
                        let release: Bool
                        func release() {}
                    #endif
                    func foo() {}
                }
            #else
                struct Foo {}
            #endif
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentIfConfig: true)
        )
    }

    // MARK: - Trailing Comment

    func test_trailingComment1() throws
    {
        let source = """
            if true {
                    // hello
            }
            """

        let expected = """
            if true {
                // hello
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_trailingComment2() throws
    {
        let source = """
            public func xit() {
                func foo() {
                            // noop
                }
                        // Do nothing
            }
            """

        let expected = """
            public func xit() {
                func foo() {
                    // noop
                }
                // Do nothing
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter()
        )
    }

    func test_trailingComment_ifConfigDecl_false() throws
    {
        let source = """
            #if DEBUG
                        // hello
            #else
                    // world
            #endif
            """

        let expected = """
            #if DEBUG
            // hello
            #else
            // world
            #endif
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentIfConfig: false)
        )
    }

    func test_trailingComment_ifConfigDecl_true() throws
    {
        let source = """
            #if DEBUG
                        // hello
            #else
                    // world
            #endif
            """

        let expected = """
            #if DEBUG
                // hello
            #else
                // world
            #endif
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(shouldIndentIfConfig: true)
        )
    }

    /// - Note: This behavior is not same as Xcode indenter.
    func test_skipsCommentedLine_true() throws
    {
        let source = """
            public func xit() {
                func foo() {
                            // doc
            //        func thisCodeWillNotBeIndented() {}

                // end
                }
                                    // doc
            //    func thisCodeWillNotBeIndented2() {}

                            // end
            }
            """

        let expected = """
            public func xit() {
                func foo() {
                    // doc
            //        func thisCodeWillNotBeIndented() {}

                    // end
                }
                // doc
            //    func thisCodeWillNotBeIndented2() {}

                // end
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(skipsCommentedLine: true)
        )
    }

    func test_skipsCommentedLine_false() throws
    {
        let source = """
            public func xit() {
                func foo() {
                            // doc
            //        func thisCodeWillNotBeIndented() {}

                // end
                }
                                    // doc
            //    func thisCodeWillNotBeIndented2() {}

                            // end
            }
            """

        let expected = """
            public func xit() {
                func foo() {
                    // doc
                    //        func thisCodeWillNotBeIndented() {}

                    // end
                }
                // doc
                //    func thisCodeWillNotBeIndented2() {}

                // end
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(skipsCommentedLine: false)
        )
    }

    // MARK: - Complex

    func test_complex1() throws
    {
        let source = """
            class Foo {
            init(x: Int = f()) {
            print()
            }

            let x = f {
            return
            }
            .foo
            }

            let bar = 1
            """

        let expected = """
            class Foo {
                init(x: Int = f()) {
                    print()
                }

                let x = f {
                    return
                }
                    .foo
            }

            let bar = 1
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(skipsCommentedLine: false)
        )
    }

    func test_complex2() throws
    {
        let source = """
            class Foo {
                static let shared = Foo()

                init() {
                print()
                }

                private var foo: Foo = run {
                return foo()
                }
                .bar
            }

            extension Foo {
                func bar() {
                    print()
                }
            }
            """

        let expected = """
            class Foo {
                static let shared = Foo()

                init() {
                    print()
                }

                private var foo: Foo = run {
                    return foo()
                }
                    .bar
            }

            extension Foo {
                func bar() {
                    print()
                }
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(skipsCommentedLine: false)
        )
    }

    func test_complex3() throws
    {
        let source = """
            struct Foo {
            init() {
            run(value)

            foo
            .bar
            }

            func baz() {}
            }
            """

        let expected = """
            struct Foo {
                init() {
                    run(value)

                    foo
                        .bar
                }

                func baz() {}
            }
            """

        try runTest(
            source: source,
            expected: expected,
            using: BlockItemIndenter(skipsCommentedLine: false)
        )
    }
}
