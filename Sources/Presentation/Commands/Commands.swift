import SwiftCLI

struct Commands {
    class DeliveryCost: Command {
        let name = "delivery-cost"
        let shortDescription = "Calculates delivery cost"

        func execute() throws  {
            DeliveryCostFlow().start()
        }
    }

    class GetAllOffers: Command {
        let name = "get-all-offers"
        let shortDescription = "Get all offers"

        func execute() throws  {
            OffersController().displayOffers()
        }
    }

    class AddNewOffer: Command {
        let name = "add-new-offer"
        let shortDescription = "Add new offer"

        func execute() throws  {
            OffersController().addNewOffer()
        }
    }
}
