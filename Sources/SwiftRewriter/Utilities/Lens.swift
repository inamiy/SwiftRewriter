import Foundation
import SwiftSyntax
import FunOptics

// MARK: - StructDeclSyntax

extension Lens where Whole == StructDeclSyntax, Part == AttributeListSyntax?
{
    /// Cursor 0
    static let attributes = Lens(
        get: { $0.attributes },
        set: { $0.withAttributes($1) }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == ModifierListSyntax?
{
    /// Cursor 1
    static let modifiers = Lens(
        get: { $0.modifiers },
        set: { $0.withModifiers($1) }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == TokenSyntax
{
    /// Cursor 2
    static let structKeyword = Lens(
        get: { $0.structKeyword },
        set: { $0.withStructKeyword($1) }
    )

    /// Cursor 3
    static let identifier = Lens(
        get: { $0.identifier },
        set: { $0.withIdentifier($1) }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == GenericParameterClauseSyntax?
{
    /// Cursor 4
    static let genericParameterClause = Lens(
        get: { $0.genericParameterClause },
        set: { $0.withGenericParameterClause($1) }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == TypeInheritanceClauseSyntax?
{
    /// Cursor 5
    static let inheritanceClause = Lens(
        get: { $0.inheritanceClause },
        set: { $0.withInheritanceClause($1) }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == GenericWhereClauseSyntax?
{
    /// Cursor 6
    static let genericWhereClause = Lens(
        get: { $0.genericWhereClause },
        set: { $0.withGenericWhereClause($1) }
    )
}

extension Lens where Whole == StructDeclSyntax, Part == MemberDeclBlockSyntax
{
    /// Cursor 7
    static let body = Lens(
        get: { $0.members },
        set: { $0.withMembers($1) }
    )
}

// MARK: - InitializerDeclSyntax

extension Lens where Whole == InitializerDeclSyntax, Part == AttributeListSyntax?
{
    /// Cursor 0
    static let attributes = Lens(
        get: { $0.attributes },
        set: { $0.withAttributes($1) }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == ModifierListSyntax?
{
    /// Cursor 1
    static let modifiers = Lens(
        get: { $0.modifiers },
        set: { $0.withModifiers($1) }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == TokenSyntax
{
    /// Cursor 2
    static let initKeyword = Lens(
        get: { $0.initKeyword },
        set: { $0.withInitKeyword($1) }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == TokenSyntax?
{
    /// Cursor 3
    static let optionalMark = Lens(
        get: { $0.optionalMark },
        set: { $0.withOptionalMark($1) }
    )

    /// Cursor 6
    static let throwsOrRethrowsKeyword = Lens(
        get: { $0.throwsOrRethrowsKeyword },
        set: { $0.withThrowsOrRethrowsKeyword($1) }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == GenericParameterClauseSyntax?
{
    /// Cursor 4
    static let genericParameterClause = Lens(
        get: { $0.genericParameterClause },
        set: { $0.withGenericParameterClause($1) }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == ParameterClauseSyntax
{
    /// Cursor 5
    static let parameters = Lens(
        get: { $0.parameters },
        set: { $0.withParameters($1) }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == GenericWhereClauseSyntax?
{
    /// Cursor 7
    static let genericWhereClause = Lens(
        get: { $0.genericWhereClause },
        set: { $0.withGenericWhereClause($1) }
    )
}

extension Lens where Whole == InitializerDeclSyntax, Part == CodeBlockSyntax?
{
    /// Cursor 8
    static let body = Lens(
        get: { $0.body },
        set: { $0.withBody($1) }
    )
}

// MARK: FunctionDeclSyntax

extension Lens where Whole == FunctionDeclSyntax, Part == AttributeListSyntax?
{
    /// Cursor 0
    static let attributes = Lens(
        get: { $0.attributes },
        set: { $0.withAttributes($1) }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == ModifierListSyntax?
{
    /// Cursor 1
    static let modifiers = Lens(
        get: { $0.modifiers },
        set: { $0.withModifiers($1) }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == TokenSyntax
{
    /// Cursor 2
    static let funcKeyword = Lens(
        get: { $0.funcKeyword },
        set: { $0.withFuncKeyword($1) }
    )

    /// Cursor 3
    static let identifier = Lens(
        get: { $0.identifier },
        set: { $0.withIdentifier($1) }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == GenericParameterClauseSyntax?
{
    /// Cursor 4
    static let genericParameterClause = Lens(
        get: { $0.genericParameterClause },
        set: { $0.withGenericParameterClause($1) }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == FunctionSignatureSyntax
{
    /// Cursor 5
    static let signature = Lens(
        get: { $0.signature },
        set: { $0.withSignature($1) }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == GenericWhereClauseSyntax?
{
    /// Cursor 6
    static let genericWhereClause = Lens(
        get: { $0.genericWhereClause },
        set: { $0.withGenericWhereClause($1) }
    )
}

extension Lens where Whole == FunctionDeclSyntax, Part == CodeBlockSyntax?
{
    /// Cursor 7
    static let body = Lens(
        get: { $0.body },
        set: { $0.withBody($1) }
    )
}

// MARK: - FunctionSignatureSyntax

extension Lens where Whole == FunctionSignatureSyntax, Part == ParameterClauseSyntax
{
    /// Cursor 0
    static let input = Lens(
        get: { $0.input },
        set: { $0.withInput($1) }
    )
}

extension Lens where Whole == FunctionSignatureSyntax, Part == TokenSyntax?
{
    /// Cursor 1
    static let throwsOrRethrowsKeyword = Lens(
        get: { $0.throwsOrRethrowsKeyword },
        set: { $0.withThrowsOrRethrowsKeyword($1) }
    )
}

extension Lens where Whole == FunctionSignatureSyntax, Part == ReturnClauseSyntax?
{
    /// Cursor 2
    static let output = Lens(
        get: { $0.output },
        set: { $0.withOutput($1) }
    )
}

// MARK: - ParameterClauseSyntax

extension Lens where Whole == ParameterClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let leftParen = Lens(
        get: { $0.leftParen },
        set: { $0.withLeftParen($1) }
    )

    /// Cursor 2
    static let rightParen = Lens(
        get: { $0.rightParen },
        set: { $0.withRightParen($1) }
    )
}

extension Lens where Whole == ParameterClauseSyntax, Part == FunctionParameterListSyntax
{
    /// Cursor 1
    static let parameterList = Lens(
        get: { $0.parameterList },
        set: { $0.withParameterList($1) }
    )
}

// MARK: - InitializerClauseSyntax

extension Lens where Whole == InitializerClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let equal = Lens(
        get: { $0.equal },
        set: { $0.withEqual($1) }
    )
}

extension Lens where Whole == InitializerClauseSyntax, Part == ExprSyntax
{
    /// Cursor 1
    static let value = Lens(
        get: { $0.value },
        set: { $0.withValue($1) }
    )
}

// MARK: - WhereClauseSyntax

extension Lens where Whole == WhereClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let whereKeyword = Lens(
        get: { $0.whereKeyword },
        set: { $0.withWhereKeyword($1) }
    )
}

extension Lens where Whole == WhereClauseSyntax, Part == ExprSyntax
{
    /// Cursor 1
    static let guardResult = Lens(
        get: { $0.guardResult },
        set: { $0.withGuardResult($1) }
    )
}

// MARK: - ReturnClauseSyntax

extension Lens where Whole == ReturnClauseSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let arrow = Lens(
        get: { $0.arrow },
        set: { $0.withArrow($1) }
    )
}

extension Lens where Whole == ReturnClauseSyntax, Part == TypeSyntax
{
    /// Cursor 1
    static let returnType = Lens(
        get: { $0.returnType },
        set: { $0.withReturnType($1) }
    )
}

// MARK: - GenericWhereClauseSyntax

extension Lens where Whole == GenericWhereClauseSyntax, Part == TokenSyntax
{
    static let whereKeyword = Lens(
        get: { $0.whereKeyword },
        set: { $0.withWhereKeyword($1) }
    )
}

extension Lens where Whole == GenericWhereClauseSyntax, Part == GenericRequirementListSyntax
{
    static let requirementList = Lens(
        get: { $0.requirementList },
        set: { $0.withRequirementList($1) }
    )
}

// MARK: - GuardStmtSyntax

extension Lens where Whole == GuardStmtSyntax, Part == TokenSyntax
{
    static let elseKeyword = Lens(
        get: { $0.elseKeyword },
        set: { $0.withElseKeyword($1) }
    )
}

extension Lens where Whole == GuardStmtSyntax, Part == CodeBlockSyntax
{
    static let body = Lens(
        get: { $0.body },
        set: { $0.withBody($1) }
    )
}

// MARK: - TernaryExprSyntax

extension Lens where Whole == TernaryExprSyntax, Part == ExprSyntax
{
    /// Cursor 0
    static let conditionExpression = Lens(
        get: { $0.conditionExpression },
        set: { $0.withConditionExpression($1) }
    )

    /// Cursor 2
    static let firstChoice = Lens(
        get: { $0.firstChoice },
        set: { $0.withFirstChoice($1) }
    )

    /// Cursor 4
    static let secondChoice = Lens(
        get: { $0.secondChoice },
        set: { $0.withSecondChoice($1) }
    )
}

extension Lens where Whole == TernaryExprSyntax, Part == TokenSyntax
{
    /// Cursor 1
    static let questionMark = Lens(
        get: { $0.questionMark },
        set: { $0.withQuestionMark($1) }
    )

    /// Cursor 3
    static let colonMark = Lens(
        get: { $0.colonMark },
        set: { $0.withColonMark($1) }
    )
}

// MARK: - FunctionCallExprSyntax

extension Lens where Whole == FunctionCallExprSyntax, Part == ExprSyntax
{
    /// Cursor 0
    static let calledExpression = Lens(
        get: { $0.calledExpression },
        set: { $0.withCalledExpression($1) }
    )
}

extension Lens where Whole == FunctionCallExprSyntax, Part == FunctionCallArgumentListSyntax
{
    /// Cursor 2
    static let argumentList = Lens(
        get: { $0.argumentList },
        set: { $0.withArgumentList($1) }
    )
}

extension Lens where Whole == FunctionCallExprSyntax, Part == ClosureExprSyntax?
{
    /// Cursor 4
    static let trailingClosure = Lens(
        get: { $0.trailingClosure },
        set: { $0.withTrailingClosure($1) }
    )
}

extension Lens where Whole == FunctionCallExprSyntax, Part == TokenSyntax?
{
    /// Cursor 1
    static let leftParen = Lens(
        get: { $0.leftParen },
        set: { $0.withLeftParen($1) }
    )

    /// Cursor 3
    static let rightParen = Lens(
        get: { $0.rightParen },
        set: { $0.withRightParen($1) }
    )
}

// MARK: - MemberAccessExprSyntax

extension Lens where Whole == MemberAccessExprSyntax, Part == ExprSyntax?
{
    /// Cursor 0
    static let base = Lens(
        get: { $0.base },
        set: { $0.withBase($1) }
    )
}

extension Lens where Whole == MemberAccessExprSyntax, Part == TokenSyntax
{
    /// Cursor 1
    static let dot = Lens(
        get: { $0.dot },
        set: { $0.withDot($1) }
    )

    /// Cursor 2
    static let name = Lens(
        get: { $0.name },
        set: { $0.withName($1) }
    )
}

extension Lens where Whole == MemberAccessExprSyntax, Part == DeclNameArgumentsSyntax?
{
    /// Cursor 3
    static let declNameArguments = Lens(
        get: { $0.declNameArguments },
        set: { $0.withDeclNameArguments($1) }
    )
}

// MARK: - ClosureExprSyntax

extension Lens where Whole == ClosureExprSyntax, Part == TokenSyntax
{
    /// Cursor 0
    static let leftBrace = Lens(
        get: { $0.leftBrace },
        set: { $0.withLeftBrace($1) }
    )

    /// Cursor 3
    static let rightBrace = Lens(
        get: { $0.rightBrace },
        set: { $0.withRightBrace($1) }
    )
}

extension Lens where Whole == ClosureExprSyntax, Part == ClosureSignatureSyntax?
{
    /// Cursor 1
    static let signature = Lens(
        get: { $0.signature },
        set: { $0.withSignature($1) }
    )
}

extension Lens where Whole == ClosureExprSyntax, Part == CodeBlockItemListSyntax
{
    /// Cursor 2
    static let statements = Lens(
        get: { $0.statements },
        set: { $0.withStatements($1) }
    )
}

// MARK: - SyntaxCollection

extension Lens where Whole: SyntaxCollection, Part == Whole.Element
{
    static func child(at index: Int) -> Lens
    {
        return Lens(
            get: { $0.child(at: index) as! Part },
            set: { $0.replacing(childAt: index, with: $1) }
        )
    }
}

// MARK: - TokenSyntax

extension Lens where Whole == TokenSyntax, Part == [TriviaPiece]
{
    static let leadingTrivia = Lens(
        get: { $0.leadingTrivia.pieces },
        set: { $0.withLeadingTrivia(.init(pieces: $1)) }
    )

    static let trailingTrivia = Lens(
        get: { $0.trailingTrivia.pieces },
        set: { $0.withTrailingTrivia(.init(pieces: $1)) }
    )
}

// MARK: - Helpers

/// Force-cast `Lens<Whole, Part>` to `Lens<Whole, Part2>`
/// e.g. converting `ExprSyntax` protocol type to concrete type.
func cast<Whole, Part, Part2>(_ lens: Lens<Whole, Part>) -> Lens<Whole, Part2>
{
    return Lens<Whole, Part2>(
        get: { lens.get($0) as! Part2 },
        set: { lens.set($0, $1 as! Part) }
    )
}
