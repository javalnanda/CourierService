import Foundation
struct AppRouter {
    let courierDeliveryPresenter: CourierDeliveryPresentable
    let offersPresenter: OffersPresentable
    let cli: CLIService

    func showMainMenu(displayWelcomeMsg: Bool = false) {
        if displayWelcomeMsg {
            displayWelcomeMessage()
        }
        let input = cli.getUserChoice()
        processInput(serviceOpion: input)
    }

    private func displayWelcomeMessage() {
        let welcomeMsg = """
                        \n
                        =====================================
                        = Welcome to Kiki's Courier Service =
                        =====================================
                        """
        cli.display(output: welcomeMsg)
    }

    private func processInput(serviceOpion: ServiceOption) {
        switch serviceOpion {
        case .deliveryCost: courierDeliveryPresenter.calculateCost()
        case .deliveryTime: courierDeliveryPresenter.calculateTime()
        case .getAllOffers: offersPresenter.displayOffers()
        case .addNewOffer: offersPresenter.addNewOffer()
        case .removeOffer: offersPresenter.removeOffer()
        case .exit: exit(0)
        }

        if !isRunningTests {
            // This prevents command line process from exiting and displays the menu again
            // after finishing previous request.
            showMainMenu()
        }
    }
}

var isRunningTests: Bool {
    let isTestProcess = ProcessInfo.processInfo.processName.contains("xctest") ||
    (ProcessInfo.processInfo.environment["isRunningTest"] != nil)
    return isTestProcess
}
