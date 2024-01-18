import SwiftCLI

struct DeliveryCostFlow {
    let invoiceGenerator = DeliveryInvoiceGeneratorFactory().build()

    func start() {
        let baseDeliveryCost = Input.readDouble(prompt: "Please enter the base delivery cost:")
        let noOfPackages = Input.readInt(prompt: "Please enter the number of packages to deliver:")
        
        var packages: [Package] = []
        for i in 0 ..< noOfPackages {
            print("\nEnter details of package\(i+1):")
            let packageId = Input.readLine(prompt: "Enter package Id:")
            let packageWeight = Input.readDouble(prompt: "Enter package weight in kg:")
            let distanceToDestination = Input.readDouble(prompt: "Enter distance to destination:")
            let offerCode = Input.readLine(prompt: "Enter Offer Code:")
            let package = Package(
                id: packageId,
                weightInKg: packageWeight,
                distanceToDestination: distanceToDestination,
                offerCode: offerCode
            )
            packages.append(package)
        }

        let generatedInvoices = invoiceGenerator.generateInvoices(baseDeliveryCost: baseDeliveryCost, packages: packages)
        print("Invoices::")
        print(generatedInvoices)
    }
}
