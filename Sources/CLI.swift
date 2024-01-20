import SwiftCLI

enum ServiceOption: Int, CaseIterable {
    case deliveryCost
    case getAllOffers
    case addNewOffer
    case removeOffer
    case exit

    var description: String {
        switch self {
        case .deliveryCost: return "Calculate Delivery Cost"
        case .getAllOffers: return "Get all offers"
        case .addNewOffer: return "Add new offer"
        case .removeOffer: return "Remove offer"
        case .exit: return "Exit"
        }
    }
}

typealias PackageData = (id: String, weight: Double, distance: Double, offer: String)
typealias OfferData = (
    offerCode: String,
    discount: Double,
    minWeight: Double,
    maxWeight: Double,
    minDistance: Double,
    maxDistance: Double
)

struct CLI {
    static let shared = CLI()
    func getUserChoice() -> ServiceOption {
        print("\nWhat would you like to do?")
        for (index, option) in ServiceOption.allCases.enumerated() {
            print("\(index + 1). \(option.description)")
        }
        let input = Input.readInt(prompt: "Enter choice:", validation: [.within(1...ServiceOption.allCases.count)])
        return ServiceOption(rawValue: input - 1)!
    }

    func getInputsForCostCalculation() -> (baseDeliveryCost: Double, packages: [PackageData]) {
        let baseDeliveryCost = Input.readDouble(prompt: "Please enter the base delivery cost:")
        let noOfPackages = Input.readInt(prompt: "Please enter the number of packages to deliver:")

        var packages: [PackageData] = []
        for i in 0 ..< noOfPackages {
            print("\nPlease enter the details of package\(i + 1):")
            let packageId = Input.readLine(prompt: "Enter package Id:")
            let packageWeight = Input.readDouble(prompt: "Enter package weight in kg:")
            let distanceToDestination = Input.readDouble(prompt: "Enter distance to destination:")
            let offerCode = Input.readLine(prompt: "Enter Offer Code:")
            let package = PackageData(
                id: packageId,
                weight: packageWeight,
                distance: distanceToDestination,
                offer: offerCode
            )
            packages.append(package)
        }
        return (baseDeliveryCost, packages)
    }

    func getNewOfferData() -> OfferData {
        print("\nPlease enter the details of new offer:")
        let offerCode = Input.readLine(prompt: "Enter Offer Code:").uppercased()
        let discount = Input.readDouble(prompt: "Enter discount in percentage:")
        let minDistance = Input.readDouble(prompt: "Enter minimum distance to deliver for the offer to be valid:")
        let maxDistance = Input.readDouble(prompt: "Enter maximum distance to deliver for the offer to be valid:")
        let minWeight = Input.readDouble(prompt: "Enter minimum weight of the package for the offer to be valid:")
        let maxWeight = Input.readDouble(prompt: "Enter maximum weight of the package for the offer to be valid:")
        return OfferData(
            offerCode: offerCode,
            discount: discount,
            minWeight: minWeight,
            maxWeight: maxWeight,
            minDistance: minDistance,
            maxDistance: maxDistance
        )
    }

    func getOfferCodeToRemove() -> String {
        return Input.readLine(prompt: "Please enter offer code of Offer to be removed:")
    }

    func display(output: String) {
        print(output)
    }
}
