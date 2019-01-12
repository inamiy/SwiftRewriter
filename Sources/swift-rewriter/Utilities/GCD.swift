import Foundation

/// Helper function to print difference in seconds.
func - (t2: DispatchTime, t1: DispatchTime) -> TimeInterval
{
    return Double(t2.uptimeNanoseconds - t1.uptimeNanoseconds) / 1e9
}
