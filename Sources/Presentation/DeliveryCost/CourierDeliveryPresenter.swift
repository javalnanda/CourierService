import Table

protocol CourierDeliveryPresentable {
    func calculateCost()
    func calculateTime()
}

struct CourierDeliveryPresenter: CourierDeliveryPresentable {
    let courierDelivery: CourierDeliveryService
    let cli: CLIService

    func calculateCost() {
        let (baseDeliveryCost, packages) = cli.getInputsForCostCalculation()
        let packagesWithOffers = packages.map { $0.toPackageWithOffers() }
        let costOfDeliveries = courierDelivery.calculateCostOfDeliveries(
            baseDeliveryCost: baseDeliveryCost,
            packages: packagesWithOffers
        )
        displayCost(costOfDeliveries: costOfDeliveries)
    }

    func calculateTime() {
        let (baseDeliveryCost, packages) = cli.getInputsForCostCalculation()
        let vehicleInfo = cli.getVehicleInfo()
        let packagesWithOffers = packages.map { $0.toPackageWithOffers() }
        let costAndTimeOfDeliveries = courierDelivery.calcuateCostAndTimeOfDeliveries(
            baseDeliveryCost: baseDeliveryCost,
            packages: packagesWithOffers,
            numberOfVehicles: vehicleInfo.numberOfVehicles,
            vehicleSpec: VehicleSpecification(
                maxSpeed: vehicleInfo.maxSpeed,
                maxWeightCapacity: vehicleInfo.maxWeightCapacity
            )
        )
        displayCostAndTime(costAndTimeOfDeliveries: costAndTimeOfDeliveries)
    }

    private func displayCost(costOfDeliveries: [DeliveryCost]) {
        var tabularData = costOfDeliveries.map { deliveryCost in
            [
                "\(deliveryCost.packageId)",
                "\(deliveryCost.discount)",
                "\(deliveryCost.totalCost)"
            ]
        }
        let headerData = ["PackageId", "Discount", "Total Cost"]
        tabularData.insert(headerData, at: 0)
        let table = try? Table(data: tabularData).table()
        cli.display(output: table ?? "\(costOfDeliveries)")
    }

    private func displayCostAndTime(costAndTimeOfDeliveries: [DeliveryCostAndTime]) {
        var tabularData = costAndTimeOfDeliveries.map { costAndTime in
            [
                "\(costAndTime.packageId)",
                "\(costAndTime.discount)",
                "\(costAndTime.totalCost)",
                "\(costAndTime.estimatedDeliveryTime)"
            ]
        }
        let headerData = ["PackageId", "Discount", "Total Cost", "Estimated Delivery Time"]
        tabularData.insert(headerData, at: 0)
        let table = try? Table(data: tabularData).table()
        cli.display(output: table ?? "\(costAndTimeOfDeliveries)")
    }
}

extension PackageData {
    func toPackageWithOffers() -> PackageWithOffer {
        PackageWithOffer(
            id: id,
            weightInKg: weight,
            distanceToDestination: distance,
            offerCode: offer
        )
    }
}
