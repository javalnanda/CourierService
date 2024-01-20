import SwiftCLI

struct AppRouter {
    private let courierDeliveryPresenter = CourierDeliveryPresenter()
    private let offersPresenter = OffersPresenterFactory().build()

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
        case 1: courierDeliveryPresenter.calculateCost()
        case 2: offersPresenter.displayOffers()
        case 3: offersPresenter.addNewOffer()
        case 4: offersPresenter.removeOffer()
        case 5: exit(0)
        default: print("Please enter valid choice")
        }
        showMenu()
    }
}
