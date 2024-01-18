import SwiftCLI

struct Commands {
    class DeliveryCost: Command {
        let name = "delivery-cost"
        let shortDescription = "Calculates delivery cost"

        func execute() throws  {
            DeliveryCostFlow().start()
        }
    }
}
