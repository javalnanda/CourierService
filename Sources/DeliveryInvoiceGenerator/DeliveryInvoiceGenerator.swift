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
