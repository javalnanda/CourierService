import Table

struct CourierDeliveryPresenter {
    let courierDelivery: CourierDelivery
    let cli = CLI.shared

    func calculateCost() {
        let (baseDeliveryCost, packages) = cli.getInputsForCostCalculation()
        let packagesWithOffers = packages.map { packageData in
            PackageWithOffer(
                id: packageData.id,
                weightInKg: packageData.weight,
                distanceToDestination: packageData.distance,
                offerCode: packageData.offer
            )
        }
        let costOfDeliveries = courierDelivery.calculateCostOfDeliveries(
            baseDeliveryCost: baseDeliveryCost,
            packages: packagesWithOffers
        )
        displayOutput(costOfDeliveries: costOfDeliveries)
    }

    private func displayOutput(costOfDeliveries: [DeliveryCost]) {
        var tabularData = costOfDeliveries.map { deliveryInvoice in
            [
                "\(deliveryInvoice.packageId)",
                "\(deliveryInvoice.discount)",
                "\(deliveryInvoice.totalCost)"
            ]
        }
        let headerData = ["PackageId", "Discount", "Total Cost"]
        tabularData.insert(headerData, at: 0)
        let table = try? Table(data: tabularData).table()
        CLI.shared.display(output: table ?? "\(costOfDeliveries)")
    }
}
