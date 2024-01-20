import SwiftCLI

struct AppRouter {
    private let deliveryFlow = DeliveryCostFlow()
    private let offersController = OffersController()

    func start() {
        showMenu()
    }

    private func showMenu() {
        print("""
          What would you like to do?
          1. Calculate Delivery Cost
          2. Get all offers
          3. Enter New Offer
          4. Remove Offer
          5. Exit
          """)
        let input = Input.readInt(prompt: "Enter choice:")
        switch input {
        case 1: deliveryFlow.start()
        case 2: offersController.displayOffers()
        case 3: offersController.addNewOffer()
        case 4: offersController.removeOffer()
        case 5: exit(0)
        default: print("Please enter valid choice")
        }
        showMenu()
    }
}
