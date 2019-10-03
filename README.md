# 📝 SwiftRewriter

[![Swift 5.1](https://img.shields.io/badge/swift-5.1-orange.svg?style=flat)](https://swift.org/download/)
[![Build Status](https://travis-ci.org/inamiy/SwiftRewriter.svg?branch=master)](https://travis-ci.org/inamiy/SwiftRewriter)

Swift code formatter using [SwiftSyntax](https://github.com/apple/swift-syntax).

**Requirements:** Swift 5.1 (Xcode 11.0) + SwiftSyntax 0.50100.0

See also my [iOSConf SG 2019](https://2019.iosconf.sg) talk for more detail:

- Slide: [Making your own Code Formatter in Swift \- Speaker Deck](https://speakerdeck.com/inamiy/making-your-own-code-formatter-in-swift)
- Video: [Make your own code formatter in Swift – iOS Conf SG 2019 – Learn Talks](https://learntalks.com/2019/01/make-your-own-code-formatter-in-swift-ios-conf-sg-2019/)

## Overview

1. **`SwiftRewriter`**: Collection of reusable & composable `SyntaxRewriter`s
2. **`swift-rewriter`**: Simple command-line executable

## How to use

```bash
$ swift build
$ swift run swift-rewriter help

Available commands:

   help        Display general or command-specific help
   print-ast   print AST from file or string
   run         Auto-correct code in the file or directory

# Auto-correct code in the directory
$ swift run swift-rewriter run --path /path/to/file-or-directory
```

### Configuration

In `swift-rewriter` CLI tool, rewriting rules are configured in [rewriter.swift](Sources/swift-rewriter/rewriter.swift) (configuration file e.g. yaml or json is not supported yet).

- [rewriter.swift](Sources/swift-rewriter/rewriter.swift)

Please change the configuration as you like (you can make your own rewriter and combine!), and `swift build & run`.

```swift
// rewriter.swift

import SwiftRewriter

/// Global rewriter.
var rewriter: Rewriter {
    return
        // Comment
        >>> HeaderCopyrightTrimmer()

        // Move
        >>> ImportSorter()
//        >>> ExtensionIniter() // not useful for everyone

        // Newline
//        >>> ExtraNewliner()   // not useful for everyone
        >>> ElseNewliner(newline: false)

        // Indent
        >>> Indenter(.init(
            perIndent: .spaces(4),
            shouldIndentSwitchCase: false,
            shouldIndentIfConfig: false,
            skipsCommentedLine: true
        ))

        // Space
//        >>> ExtraSpaceTrimmer()   // may disturb manually-aligned code

        >>> ColonSpacer(spaceBefore: false, spaceAfter: true)
        >>> TernaryExprSpacer()
        >>> BinaryOperatorSpacer(spacesAround: true)

        // Ignore to not distrub user-aligned multiple assignments.
//        >>> EqualSpacer(spacesAround: true)

        >>> ArrowSpacer(spaceBefore: true, spaceAfter: true)
        >>> LeftBraceSpacer(spaceBefore: true)
        >>> LeftParenSpacer(spaceBefore: true)
        >>> TrailingSpaceTrimmer()
}
```

## `Rewriter` examples

### `Indenter`

#### Better right-brace position

```diff
@@ −1,6 +1,6 @@
 lets
     .code {
     }
     .format {
-} // this!!!
+    } // this!!!
```

P.S. This is the primary goal of making `SwiftRewriter`.

#### First-item-aware indent

```swift
    struct Foo {
                         init(bool: Bool,
              int: Int) {
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
```

will be:

```swift
struct Foo {
    init(bool: Bool,
         int: Int) {
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
```

### `HeaderCopyrightTrimmer`

```diff
@@ −1,10 +1,2 @@
-//
-//  example.swift
-//  SwiftRewriter
-//
-//  Created by Yasuhiro Inami on 2018-12-09.
-//  Copyright © 2018 Yasuhiro Inami. All rights reserved.
-//
-
 // All your code are belong to us.
```

### `ImportSorter`

```swift
import C
import B

func foo() {}

import A
import D
```

will be:

```swift
import A
import B
import C
import D

func foo() {}
```

### `ExtensionIniter`

This rewriter moves the code to enable `struct`'s [memberwise initializer](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html).

```swift
struct Foo {
    let int: Int
    init(int: Int) {
        self.int = int
    }
    init() {
        self.int = 0
    }
}
```

```diff
@@ −1,9 +1,12 @@
 struct Foo {
     let int: Int
+}
+
+extension Foo {
     init(int: Int) {
         self.int = int
     }
     init() {
         self.int = 0
     }
 }
```

### `ExtraNewliner` **(Work in Progress)**

This rewriter adds a newline when code is too dense.

```swift
import Foundation
var computed1: Int = 1
var computed2: Int = { return 2 }
/// doc
var computed3: Int = { return 3 }
/// doc
var computedBlock: String {
    return ""
}
func send() -> Observable<Void> {
    return apiSession
        .send(request)
        .do(onError: { [weak self] error in
            guard let me = self else { return }
            me.doSomething()
        })
        .do(onError: { [weak self] error in
            guard let me = self else { return }
            me.doSomething()
            me.doSomething()
        })
}
```

will be:

```swift
import Foundation

var computed1: Int = 1
var computed2: Int = { return 2 }

/// doc
var computed3: Int = { return 3 }

/// doc
var computedBlock: String {
    return ""
}

func send() -> Observable<Void> {
    return apiSession
        .send(request)
        .do(onError: { [weak self] error in
            guard let me = self else { return }
            me.doSomething()
        })
        .do(onError: { [weak self] error in
            guard let me = self else { return }

            me.doSomething()
            me.doSomething()
        })
}
```

## Roadmap / TODO

- [ ] Add configuration file support
- [ ] Automatic code folding
- [ ] Move properties above method (for "states" readability)
- [ ] Move inner types to `extension` scope (for "states" readability)
- [ ] Align multiline `=` assignments
- [ ] \(Your idea comes here 💡\)

## Acknowledgement

- [Improving Swift Tools with libSyntax](https://academy.realm.io/posts/improving-swift-tools-with-libsyntax-try-swift-haskin-2017/) by @harlanhaskins
- [Creating Refactoring Transformations for Swift](https://www.skilled.io/u/swiftsummit/creating-refactoring-transformations-for-swift) by @nkcsgexi
- [try! Swift Tokyo 2018 - AST Meta-programming](https://www.youtube.com/watch?v=XG3yxw8lRJc) by @kishikawakatsumi
	- [swiftfmt](https://github.com/kishikawakatsumi/swiftfmt)
	- [swift-ast-explorer-playground](https://github.com/kishikawakatsumi/swift-ast-explorer-playground)
- [SwiftSyntax - NSHipster](https://nshipster.com/swiftsyntax/) by @mattt
- [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftSyntax benchmarking](https://twitter.com/simjp/status/1066572820715462658) by @jpsim et al.
	- [Evaluating SwiftSyntax for use in SwiftLint - JP Simard - Swift Developer](https://www.jpsim.com/evaluating-swiftsyntax-for-use-in-swiftlint/)
	- [Speeding up SwiftSyntax by using the parser directly - Development / Compiler - Swift Forums](https://forums.swift.org/t/speeding-up-swiftsyntax-by-using-the-parser-directly/18493)

## License

[MIT](LICENSE)
