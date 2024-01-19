import SwiftCLI

struct CourierService {
    static var offerStore = OfferStore()
    func main() {
        showMenu()
    }

    private func showMenu() {
        print("""
          What would you like to do?
          1. Calculate Delivery Cost
          2. Get all offers
          3. Enter New Offer
          4. Exit
          """)
        let input = Input.readInt(prompt: "Enter choice:")
        switch input {
        case 1: DeliveryCostFlow().start()
        case 2: OffersController().displayOffers()
        case 3: OffersController().addNewOffer()
        case 4: exit(0)
        default: print("Please enter valid choice")
        }
        showMenu()
    }
}
