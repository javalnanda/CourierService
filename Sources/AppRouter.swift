import SwiftCLI

struct AppRouter {
    private let courierDeliveryPresenter = CourierDeliveryPresenterFactory().build()
    private let offersPresenter = OffersPresenterFactory().build()

    func showMainMenu() {
        let input = CLI.shared.getUserChoice()
        processInput(serviceOpion: input)
    }

    private func processInput(serviceOpion: ServiceOption) {
        switch serviceOpion {
        case .deliveryCost: courierDeliveryPresenter.calculateCost()
        case .getAllOffers: offersPresenter.displayOffers()
        case .addNewOffer: offersPresenter.addNewOffer()
        case .removeOffer: offersPresenter.removeOffer()
        case .exit: exit(0)
        }
        // This prevents command line process from exiting and displays the menu again
        // after finishing previous request
        showMainMenu()
    }
}
