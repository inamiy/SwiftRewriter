import Foundation
import SwiftSyntax

// MARK: - Lens

/// Functional getter & seter.
/// An optic used to zoom inside a product-type.
struct Lens<Whole, Part>
{
    let setter: (Whole, Part) -> Whole
    let getter: (Whole) -> Part

    static func >>> <Part2>(l: Lens<Whole, Part>, r: Lens<Part, Part2>) -> Lens<Whole, Part2>
    {
        return Lens<Whole, Part2>(
            setter: { a, c in l.setter(a, r.setter(l.getter(a), c)) },
            getter: { r.getter(l.getter($0)) }
        )
    }
}

// MARK: - Prism

/// An optic used to select part of a sum-type.
struct Prism<Whole, Part>
{
    let tryGet: (Whole) -> Part?
    let inject: (Part) -> Whole
}

func some<A>() -> Prism<A?, A>
{
    return Prism<A?, A>.init(tryGet: { $0 }, inject: { $0 })
}

func none<A>() -> Prism<A?, ()>
{
    return Prism<A?, ()>.init(
        tryGet: {
            switch $0 {
            case .none: return ()
            case .some: return .none
            }
        },
        inject: { .none }
    )
}

// MARK: - AffineTraversal

/// An optic focused on zero or one target.
///
/// - Note: This type is equivalent to Scala Monocle's `Optional`.
///
/// - SeeAlso:
///   - https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/
///   - http://oleg.fi/gists/posts/2017-03-20-affine-traversal.html
///   - https://julien-truffaut.github.io/Monocle/optics/optional.html
struct AffineTraversal<Whole, Part>
{
    let tryGet: (Whole) -> Part?
    let setter: (Whole, Part) -> Whole

    init(tryGet: @escaping (Whole) -> Part?, setter: @escaping (Whole, Part) -> Whole)
    {
        self.tryGet = tryGet
        self.setter = setter
    }

    init(lens: Lens<Whole, Part>)
    {
        self.init(tryGet: lens.getter, setter: lens.setter)
    }

    init(prism: Prism<Whole, Part>)
    {
        self.init(tryGet: prism.tryGet, setter: { prism.inject($1) })
    }
}

extension AffineTraversal
{
    static func >>> <Part2>(l: AffineTraversal<Whole, Part>, r: AffineTraversal<Part, Part2>) -> AffineTraversal<Whole, Part2>
    {
        return AffineTraversal<Whole, Part2>(
            tryGet: { whole -> Part2? in
                l.tryGet(whole).flatMap { r.tryGet($0) }
            },
            setter: { whole, part2 -> Whole in
                if let part = l.tryGet(whole) {
                    return l.setter(whole, r.setter(part, part2))
                }
                else {
                    return whole
                }
            }
        )
    }
}

func >>> <Whole, Part, Part2>(l: Lens<Whole, Part>, r: Prism<Part, Part2>) -> AffineTraversal<Whole, Part2>
{
    return .init(lens: l) >>> .init(prism: r)
}

func >>> <Whole, Part, Part2>(l: Prism<Whole, Part>, r: Lens<Part, Part2>) -> AffineTraversal<Whole, Part2>
{
    return .init(prism: l) >>> .init(lens: r)
}

func >>> <Whole, Part, Part2>(l: Lens<Whole, Part>, r: AffineTraversal<Part, Part2>) -> AffineTraversal<Whole, Part2>
{
    return .init(lens: l) >>> r
}

func >>> <Whole, Part, Part2>(l: AffineTraversal<Whole, Part>, r: Lens<Part, Part2>) -> AffineTraversal<Whole, Part2>
{
    return l >>> .init(lens: r)
}

func >>> <Whole, Part, Part2>(l: Prism<Whole, Part>, r: AffineTraversal<Part, Part2>) -> AffineTraversal<Whole, Part2>
{
    return .init(prism: l) >>> r
}

func >>> <Whole, Part, Part2>(l: AffineTraversal<Whole, Part>, r: Prism<Part, Part2>) -> AffineTraversal<Whole, Part2>
{
    return l >>> .init(prism: r)
}

// MARK: - StructDeclSyntax

extension Lens where Whole == StructDeclSyntax, Part == AttributeListSyntax?
{
    /// Cursor 0
    static let attributes = Lens(
        setter: { $0.withAttributes($1) },
        getter: { $0.attributes }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == ModifierListSyntax?
{
    /// Cursor 1
    static let modifiers = Lens(
        setter: { $0.withModifiers($1) },
        getter: { $0.modifiers }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == TokenSyntax
{
    /// Cursor 2
    static let structKeyword = Lens(
        setter: { $0.withStructKeyword($1) },
        getter: { $0.structKeyword }
    )

    /// Cursor 3
    static let identifier = Lens(
        setter: { $0.withIdentifier($1) },
        getter: { $0.identifier }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == GenericParameterClauseSyntax?
{
    /// Cursor 4
    static let genericParameterClause = Lens(
        setter: { $0.withGenericParameterClause($1) },
        getter: { $0.genericParameterClause }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == TypeInheritanceClauseSyntax?
{
    /// Cursor 5
    static let inheritanceClause = Lens(
        setter: { $0.withInheritanceClause($1) },
        getter: { $0.inheritanceClause }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == GenericWhereClauseSyntax?
{
    /// Cursor 6
    static let genericWhereClause = Lens(
        setter: { $0.withGenericWhereClause($1) },
        getter: { $0.genericWhereClause }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == MemberDeclBlockSyntax
{
    /// Cursor 7
    static let body = Lens(
        setter: { $0.withMembers($1) },
        getter: { $0.members }
    )
}

// MARK: - InitializerDeclSyntax

extension Lens where Whole == InitializerDeclSyntax, Part == AttributeListSyntax?
{
    /// Cursor 0
    static let attributes = Lens(
        setter: { $0.withAttributes($1) },
        getter: { $0.attributes }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == ModifierListSyntax?
{
    /// Cursor 1
    static let modifiers = Lens(
        setter: { $0.withModifiers($1) },
        getter: { $0.modifiers }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == TokenSyntax
{
    /// Cursor 2
    static let initKeyword = Lens(
        setter: { $0.withInitKeyword($1) },
        getter: { $0.initKeyword }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == TokenSyntax?
{
    /// Cursor 3
    static let optionalMark = Lens(
        setter: { $0.withOptionalMark($1) },
        getter: { $0.optionalMark }
    )

    /// Cursor 6
    static let throwsOrRethrowsKeyword = Lens(
        setter: { $0.withThrowsOrRethrowsKeyword($1) },
        getter: { $0.throwsOrRethrowsKeyword }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == GenericParameterClauseSyntax?
{
    /// Cursor 4
    static let genericParameterClause = Lens(
        setter: { $0.withGenericParameterClause($1) },
        getter: { $0.genericParameterClause }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == ParameterClauseSyntax
{
    /// Cursor 5
    static let parameters = Lens(
        setter: { $0.withParameters($1) },
        getter: { $0.parameters }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == GenericWhereClauseSyntax?
{
    /// Cursor 7
    static let genericWhereClause = Lens(
        setter: { $0.withGenericWhereClause($1) },
        getter: { $0.genericWhereClause }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == CodeBlockSyntax?
{
    /// Cursor 8
    static let body = Lens(
        setter: { $0.withBody($1) },
        getter: { $0.body }
    )
}

// MARK: FunctionDeclSyntax

extension Lens where Whole == FunctionDeclSyntax, Part == AttributeListSyntax?
{
    /// Cursor 0
    static let attributes = Lens(
        setter: { $0.withAttributes($1) },
        getter: { $0.attributes }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == ModifierListSyntax?
{
    /// Cursor 1
    static let modifiers = Lens(
        setter: { $0.withModifiers($1) },
        getter: { $0.modifiers }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == TokenSyntax
{
    /// Cursor 2
    static let funcKeyword = Lens(
        setter: { $0.withFuncKeyword($1) },
        getter: { $0.funcKeyword }
    )

    /// Cursor 3
    static let identifier = Lens(
        setter: { $0.withIdentifier($1) },
        getter: { $0.identifier }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == GenericParameterClauseSyntax?
{
    /// Cursor 4
    static let genericParameterClause = Lens(
        setter: { $0.withGenericParameterClause($1) },
        getter: { $0.genericParameterClause }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == FunctionSignatureSyntax
{
    /// Cursor 5
    static let signature = Lens(
        setter: { $0.withSignature($1) },
        getter: { $0.signature }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == GenericWhereClauseSyntax?
{
    /// Cursor 6
    static let genericWhereClause = Lens(
        setter: { $0.withGenericWhereClause($1) },
        getter: { $0.genericWhereClause }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == CodeBlockSyntax?
{
    /// Cursor 7
    static let body = Lens(
        setter: { $0.withBody($1) },
        getter: { $0.body }
    )
}

// MARK: - FunctionSignatureSyntax

extension Lens where Whole == FunctionSignatureSyntax, Part == ParameterClauseSyntax
{
    /// Cursor 0
    static let input = Lens(
        setter: { $0.withInput($1) },
        getter: { $0.input }
    )
}

extension Lens where Whole == FunctionSignatureSyntax, Part == TokenSyntax?
{
    /// Cursor 1
    static let throwsOrRethrowsKeyword = Lens(
        setter: { $0.withThrowsOrRethrowsKeyword($1) },
        getter: { $0.throwsOrRethrowsKeyword }
    )
}

extension Lens where Whole == FunctionSignatureSyntax, Part == ReturnClauseSyntax?
{
    /// Cursor 2
    static let output = Lens(
        setter: { $0.withOutput($1) },
        getter: { $0.output }
    )
}

// MARK: - ParameterClauseSyntax

extension Lens where Whole == ParameterClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let leftParen = Lens(
        setter: { $0.withLeftParen($1) },
        getter: { $0.leftParen }
    )

    /// Cursor 2
    static let rightParen = Lens(
        setter: { $0.withRightParen($1) },
        getter: { $0.rightParen }
    )
}

extension Lens where Whole == ParameterClauseSyntax, Part == FunctionParameterListSyntax
{
    /// Cursor 1
    static let parameterList = Lens(
        setter: { $0.withParameterList($1) },
        getter: { $0.parameterList }
    )
}

// MARK: - InitializerClauseSyntax

extension Lens where Whole == InitializerClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let equal = Lens(
        setter: { $0.withEqual($1) },
        getter: { $0.equal }
    )
}

extension Lens where Whole == InitializerClauseSyntax, Part == ExprSyntax
{
    /// Cursor 1
    static let value = Lens(
        setter: { $0.withValue($1) },
        getter: { $0.value }
    )
}

// MARK: - WhereClauseSyntax

extension Lens where Whole == WhereClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let whereKeyword = Lens(
        setter: { $0.withWhereKeyword($1) },
        getter: { $0.whereKeyword }
    )
}

extension Lens where Whole == WhereClauseSyntax, Part == ExprSyntax
{
    /// Cursor 1
    static let guardResult = Lens(
        setter: { $0.withGuardResult($1) },
        getter: { $0.guardResult }
    )
}

// MARK: - ReturnClauseSyntax

extension Lens where Whole == ReturnClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let arrow = Lens(
        setter: { $0.withArrow($1) },
        getter: { $0.arrow }
    )
}

extension Lens where Whole == ReturnClauseSyntax, Part == TypeSyntax
{
    /// Cursor 1
    static let returnType = Lens(
        setter: { $0.withReturnType($1) },
        getter: { $0.returnType }
    )
}

// MARK: - GenericWhereClauseSyntax

extension Lens where Whole == GenericWhereClauseSyntax, Part == TokenSyntax
{
    static let whereKeyword = Lens(
        setter: { $0.withWhereKeyword($1) },
        getter: { $0.whereKeyword }
    )
}

extension Lens where Whole == GenericWhereClauseSyntax, Part == GenericRequirementListSyntax
{
    static let requirementList = Lens(
        setter: { $0.withRequirementList($1) },
        getter: { $0.requirementList }
    )
}

// MARK: - GuardStmtSyntax

extension Lens where Whole == GuardStmtSyntax, Part == TokenSyntax
{
    static let elseKeyword = Lens(
        setter: { $0.withElseKeyword($1) },
        getter: { $0.elseKeyword }
    )
}

extension Lens where Whole == GuardStmtSyntax, Part == CodeBlockSyntax
{
    static let body = Lens(
        setter: { $0.withBody($1) },
        getter: { $0.body }
    )
}

// MARK: - TernaryExprSyntax

extension Lens where Whole == TernaryExprSyntax, Part == ExprSyntax
{
    /// Cursor 0
    static let conditionExpression = Lens(
        setter: { $0.withConditionExpression($1) },
        getter: { $0.conditionExpression }
    )

    /// Cursor 2
    static let firstChoice = Lens(
        setter: { $0.withFirstChoice($1) },
        getter: { $0.firstChoice }
    )

    /// Cursor 4
    static let secondChoice = Lens(
        setter: { $0.withSecondChoice($1) },
        getter: { $0.secondChoice }
    )
}

extension Lens where Whole == TernaryExprSyntax, Part == TokenSyntax
{
    /// Cursor 1
    static let questionMark = Lens(
        setter: { $0.withQuestionMark($1) },
        getter: { $0.questionMark }
    )

    /// Cursor 3
    static let colonMark = Lens(
        setter: { $0.withColonMark($1) },
        getter: { $0.colonMark }
    )
}

// MARK: - FunctionCallExprSyntax

extension Lens where Whole == FunctionCallExprSyntax, Part == ExprSyntax
{
    /// Cursor 0
    static let calledExpression = Lens(
        setter: { $0.withCalledExpression($1) },
        getter: { $0.calledExpression }
    )
}

extension Lens where Whole == FunctionCallExprSyntax, Part == FunctionCallArgumentListSyntax
{
    /// Cursor 2
    static let argumentList = Lens(
        setter: { $0.withArgumentList($1) },
        getter: { $0.argumentList }
    )
}

extension Lens where Whole == FunctionCallExprSyntax, Part == ClosureExprSyntax?
{
    /// Cursor 4
    static let trailingClosure = Lens(
        setter: { $0.withTrailingClosure($1) },
        getter: { $0.trailingClosure }
    )
}

extension Lens where Whole == FunctionCallExprSyntax, Part == TokenSyntax?
{
    /// Cursor 1
    static let leftParen = Lens(
        setter: { $0.withLeftParen($1) },
        getter: { $0.leftParen }
    )

    /// Cursor 3
    static let rightParen = Lens(
        setter: { $0.withRightParen($1) },
        getter: { $0.rightParen }
    )
}

// MARK: - MemberAccessExprSyntax

extension Lens where Whole == MemberAccessExprSyntax, Part == ExprSyntax?
{
    /// Cursor 0
    static let base = Lens(
        setter: { $0.withBase($1) },
        getter: { $0.base }
    )
}

extension Lens where Whole == MemberAccessExprSyntax, Part == TokenSyntax
{
    /// Cursor 1
    static let dot = Lens(
        setter: { $0.withDot($1) },
        getter: { $0.dot }
    )

    /// Cursor 2
    static let name = Lens(
        setter: { $0.withName($1) },
        getter: { $0.name }
    )
}

extension Lens where Whole == MemberAccessExprSyntax, Part == DeclNameArgumentsSyntax?
{
    /// Cursor 3
    static let declNameArguments = Lens(
        setter: { $0.withDeclNameArguments($1) },
        getter: { $0.declNameArguments }
    )
}

// MARK: - ClosureExprSyntax

extension Lens where Whole == ClosureExprSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let leftBrace = Lens(
        setter: { $0.withLeftBrace($1) },
        getter: { $0.leftBrace }
    )

    /// Cursor 3
    static let rightBrace = Lens(
        setter: { $0.withRightBrace($1) },
        getter: { $0.rightBrace }
    )
}

extension Lens where Whole == ClosureExprSyntax, Part == ClosureSignatureSyntax?
{
    /// Cursor 1
    static let signature = Lens(
        setter: { $0.withSignature($1) },
        getter: { $0.signature }
    )
}

extension Lens where Whole == ClosureExprSyntax, Part == CodeBlockItemListSyntax
{
    /// Cursor 2
    static let statements = Lens(
        setter: { $0.withStatements($1) },
        getter: { $0.statements }
    )
}

// MARK: - SyntaxCollection

extension Lens where Whole: SyntaxCollection, Part == Whole.Element
{
    static func child(at index: Int) -> Lens
    {
        return Lens(
            setter: { $0.replacing(childAt: index, with: $1) },
            getter: { $0.child(at: index) as! Part }
        )
    }
}

// MARK: - TokenSyntax

extension Lens where Whole == TokenSyntax, Part == [TriviaPiece]
{
    static let leadingTrivia = Lens(
        setter: { $0.withLeadingTrivia(.init(pieces: $1)) },
        getter: { $0.leadingTrivia.pieces }
    )

    static let trailingTrivia = Lens(
        setter: { $0.withTrailingTrivia(.init(pieces: $1)) },
        getter: { $0.trailingTrivia.pieces }
    )
}

// MARK: - Helpers

/// Force-cast `Lens<Whole, Part>` to `Lens<Whole, Part2>`
/// e.g. converting `ExprSyntax` protocol type to concrete type.
func cast<Whole, Part, Part2>(_ lens: Lens<Whole, Part>) -> Lens<Whole, Part2>
{
    return Lens<Whole, Part2>(
        setter: { lens.setter($0, $1 as! Part) },
        getter: { lens.getter($0) as! Part2 }
    )
}
