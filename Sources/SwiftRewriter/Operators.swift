/// infixr 5
precedencegroup ArrowPlusPrecedence
{
    associativity: right
    higherThan: AssignmentPrecedence
    lowerThan: AdditionPrecedence
}

infix operator <+> : ArrowPlusPrecedence

/// infixr 9
precedencegroup ForwardCompositionPrecedence
{
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator >>> : ForwardCompositionPrecedence
