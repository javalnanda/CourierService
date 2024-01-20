import SwiftCLI
import Table

struct DeliveryCostFlow {
    private let invoiceGenerator = CourierDeliveryFactory().build()

    func start() {
        let baseDeliveryCost = Input.readDouble(prompt: "Please enter the base delivery cost:")
        let noOfPackages = Input.readInt(prompt: "Please enter the number of packages to deliver:")

        var packages: [PackageWithOffer] = []
        for i in 0 ..< noOfPackages {
            print("\nPlease enter the details of package\(i + 1):")
            let packageId = Input.readLine(prompt: "Enter package Id:")
            let packageWeight = Input.readDouble(prompt: "Enter package weight in kg:")
            let distanceToDestination = Input.readDouble(prompt: "Enter distance to destination:")
            let offerCode = Input.readLine(prompt: "Enter Offer Code:")
            let package = PackageWithOffer(
                id: packageId,
                weightInKg: packageWeight,
                distanceToDestination: distanceToDestination,
                offerCode: offerCode
            )
            packages.append(package)
        }

        let invoices = invoiceGenerator.calculateCostOfDeliveries(baseDeliveryCost: baseDeliveryCost, packages: packages)
        displayOutput(invoices: invoices)
    }

    private func displayOutput(invoices: [DeliveryCost]) {
        var tabularData = invoices.map { deliveryInvoice in
            [
                "\(deliveryInvoice.packageId)",
                "\(deliveryInvoice.discount)",
                "\(deliveryInvoice.totalCost)"
            ]
        }
        let headerData = ["PackageId", "Discount", "Total Cost"]
        tabularData.insert(headerData, at: 0)
        let table = try? Table(data: tabularData).table()
        print(table ?? invoices)
    }
}
