import Foundation

struct Package {
    let id: String
    let weightInKg: Double
    let distanceToDestination: Double
    let offerCode: String
}

struct DeliveryInvoice: Equatable {
    let packageId: String
    let discount: Double
    let totalCost: Double
}

struct DeliveryInvoiceGenerator {
    let deliveryCostCalculator: DeliveryCostCalculator

    func generateInvoices(
        baseDeliveryCost: Double,
        packages: [Package]
    ) -> [DeliveryInvoice] {
        var invoices: [DeliveryInvoice] = []
        for package in packages {
            let totalCost = deliveryCostCalculator.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)
            invoices.append(DeliveryInvoice(packageId: package.id, discount: 0, totalCost: totalCost))
        }
        return invoices
    }
}
