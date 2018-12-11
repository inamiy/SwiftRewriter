import Commandant

/// Usage: the path to the file or directory to \(action)
func pathOption(action: String) -> Option<String>
{
    return Option(key: "path",
                  defaultValue: "",
                  usage: "the path to the file or directory to \(action)")
}

/// Usage: the path to the file or directory to \(action)
func pathOption(action: String) -> Option<String?>
{
    return Option(key: "path",
                  defaultValue: nil,
                  usage: "the path to the file or directory to \(action)")
}

/// Usage: list of paths to the files or directories to \(action)
func pathsArgument(action: String) -> Argument<[String]>
{
    return Argument(defaultValue: [""],
                    usage: "list of paths to the files or directories to \(action)")
}
