import SwiftCLI

let cli = CLI(
    name: "CourierService",
    version: "0.0.1",
    description: "Kiki's courier delivery service",
    commands: [Commands.DeliveryCost()]
)
cli.go()
