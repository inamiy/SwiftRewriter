import Foundation
import Commandant

/// Fancy `Commandant.CommandProtocol` wrapper that runs throwing function instead.
protocol CommandProtocol: Commandant.CommandProtocol
{
    /// Run command that may throw.
    func run(_ options: Options) throws
}

extension CommandProtocol
{
    // Default implementation to suppress `Result`-based handling.
    public func run(_ options: Options) -> Result<(), Swift.Error>
    {
        return Result(catching: { try run(options) })
    }
}
