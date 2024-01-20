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
        displayCost(costOfDeliveries: costOfDeliveries)
    }

    func calculateTime() {
        let (baseDeliveryCost, packages) = cli.getInputsForCostCalculation()
        let vehicleInfo = cli.getVehicleInfo()
        let packagesWithOffers = packages.map { packageData in
            PackageWithOffer(
                id: packageData.id,
                weightInKg: packageData.weight,
                distanceToDestination: packageData.distance,
                offerCode: packageData.offer
            )
        }
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
        CLI.shared.display(output: table ?? "\(costOfDeliveries)")
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
        CLI.shared.display(output: table ?? "\(costAndTimeOfDeliveries)")
    }
}
