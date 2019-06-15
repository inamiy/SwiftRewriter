import SwiftSyntax

// MARK: - SyntaxCollection

/// Workaround protocol to be used as an existential container.
public protocol _SyntaxCollection
{
    var count: Int { get }
}

/// `Syntax` + `Collection`.
///
/// - Note: Removed `where Element: Syntax` because of error:
///   > Using 'ExprSyntax' as a concrete type conforming to protocol 'Syntax' is not supported
public protocol SyntaxCollection: SwiftSyntax.SyntaxCollection, _SyntaxCollection
{
    func replacing(childAt index: Int, with syntax: Element) -> Self
}

extension Syntax
{
    /// - Complexity: O(n) performance
    /// https://github.com/apple/swift-syntax/commit/f024a1fde86e63387628dceba9103df866a5e4ba
    func child(at index: Int) -> Syntax?
    {
        return self.children.dropFirst(index).first(where: { _ in true })
    }
}

// WARNING: Conformance list is not complete.
extension CodeBlockItemListSyntax: SyntaxCollection {}
extension MemberDeclListSyntax: SyntaxCollection {}
extension ExprListSyntax: SyntaxCollection {}
extension PatternBindingListSyntax: SyntaxCollection {}
extension AccessorListSyntax: SyntaxCollection {}
extension ConditionElementListSyntax: SyntaxCollection {}
extension FunctionParameterListSyntax: SyntaxCollection {}
extension FunctionCallArgumentListSyntax: SyntaxCollection {}
extension GenericParameterListSyntax: SyntaxCollection {}
extension GenericArgumentListSyntax: SyntaxCollection {}
extension GenericRequirementListSyntax: SyntaxCollection {}
extension InheritedTypeListSyntax: SyntaxCollection {}
extension TuplePatternElementListSyntax: SyntaxCollection {}
extension TupleTypeElementListSyntax: SyntaxCollection {}
extension TupleElementListSyntax: SyntaxCollection {}
extension ArrayElementListSyntax: SyntaxCollection {}
extension DictionaryElementListSyntax: SyntaxCollection {}
extension SwitchCaseListSyntax: SyntaxCollection {}
extension CaseItemListSyntax: SyntaxCollection {}
extension PrecedenceGroupAttributeListSyntax: SyntaxCollection {}
extension IfConfigClauseListSyntax: SyntaxCollection {}

// MARK: - DeclGroupSyntax

// Workaround
extension EnumDeclSyntax: DeclGroupSyntax {}

// MARK: - NestableDeclSyntax

/// Declarations that are nestable, e.g. structs, enums, classes.
protocol NestableDeclSyntax: DeclSyntax
{
    var identifier: TokenSyntax { get }
}

extension NestableDeclSyntax
{
    /// Full identifier that supports nested structure for making extension,
    /// e.g. `extension Foo.Bar { ... }`.
    var fullIdentifier: TypeSyntax
    {
        var parent_ = self.parent

        // `parent.fullIdentifier + self.identifier` if possible.
        while let parent = parent_ {
            switch parent {
            case let parent as StructDeclSyntax:
                return SyntaxFactory.makeMemberTypeIdentifier(
                    baseType: parent.fullIdentifier,
                    period: SyntaxFactory.makePeriodToken(),
                    name: self.identifier.withoutTrivia(),
                    genericArgumentClause: nil
                )
            case let parent as EnumDeclSyntax:
                return SyntaxFactory.makeMemberTypeIdentifier(
                    baseType: parent.fullIdentifier,
                    period: SyntaxFactory.makePeriodToken(),
                    name: self.identifier.withoutTrivia(),
                    genericArgumentClause: nil
                )
            case let parent as ClassDeclSyntax:
                return SyntaxFactory.makeMemberTypeIdentifier(
                    baseType: parent.fullIdentifier,
                    period: SyntaxFactory.makePeriodToken(),
                    name: self.identifier.withoutTrivia(),
                    genericArgumentClause: nil
                )
            default:
                parent_ = parent.parent
            }
        }

        return SyntaxFactory.makeSimpleTypeIdentifier(
            name: self.identifier.withoutTrivia(),
            genericArgumentClause: nil
        )
    }
}

extension StructDeclSyntax: NestableDeclSyntax {}
extension EnumDeclSyntax: NestableDeclSyntax {}
extension ClassDeclSyntax: NestableDeclSyntax {}

// MARK: - OptionallyParenthesizedSyntax

/// `ParenthesizedSyntax` workaround.
public protocol OptionallyParenthesizedSyntax: Syntax
{
    var optionalLeftParen: TokenSyntax? { get }
    func withLeftParen(_ newChild: TokenSyntax?) -> Self

    var optionalRightParen: TokenSyntax? { get }
    func withRightParen(_ newChild: TokenSyntax?) -> Self
}

extension ParenthesizedSyntax where Self: OptionallyParenthesizedSyntax
{
    public var optionalLeftParen: TokenSyntax? { return self.leftParen }
    public var optionalRightParen: TokenSyntax? { return self.rightParen }
}

extension ParameterClauseSyntax: OptionallyParenthesizedSyntax {}

extension FunctionCallExprSyntax: OptionallyParenthesizedSyntax
{
    public var optionalLeftParen: TokenSyntax? { return self.leftParen }
    public var optionalRightParen: TokenSyntax? { return self.rightParen }
}
