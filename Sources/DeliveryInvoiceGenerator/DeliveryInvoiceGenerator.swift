struct DeliveryInvoiceGenerator {
    let deliveryCostCalculator: DeliveryCostCalculator

    func generateInvoices(
        baseDeliveryCost: Double,
        packages: [PackageWithOffer]
    ) -> [DeliveryCost] {
        var costOfDeliveries: [DeliveryCost] = []
        for package in packages {
            let deliveryCost = deliveryCostCalculator.calculateTotalEstimatedCost(
                baseDeliveryCost: baseDeliveryCost,
                package: package
            )
            costOfDeliveries.append(deliveryCost)
        }
        return costOfDeliveries
    }
}
