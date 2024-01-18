struct DeliveryInvoiceGenerator {
    let deliveryCostCalculator: DeliveryCostCalculator

    func generateInvoices(
        baseDeliveryCost: Double,
        packages: [Package]
    ) -> [DeliveryInvoice] {
        var invoices: [DeliveryInvoice] = []
        for package in packages {
            let (totalCost, discount) = deliveryCostCalculator.calculateTotalEstimatedCost(
                baseDeliveryCost: baseDeliveryCost,
                package: package
            )
            invoices.append(
                DeliveryInvoice(
                    packageId: package.id,
                    discount: discount,
                    totalCost: totalCost
                )
            )
        }
        return invoices
    }
}
