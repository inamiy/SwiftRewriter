import Foundation
import Result
import Commandant

let registry = CommandRegistry<AnyError>()

registry.register(RunCommand())
registry.register(PrintASTCommand())
registry.register(HelpCommand(registry: registry))

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}
