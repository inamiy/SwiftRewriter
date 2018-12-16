import Foundation
import Result
import Commandant

let registry = CommandRegistry<AnyError>()

registry.register(RunCommand())
//registry.register(PrintASTCommand())  // ignored in version 0.1.0
registry.register(VersionCommand())
registry.register(HelpCommand(registry: registry))

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}
