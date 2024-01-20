struct CourierDelivery {
    let deliveryCostCalculator: DeliveryCostCalculator
    let deliveryTimeCalculator: DeliveryTimeCalculator

    func calculateCostOfDeliveries(
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

    func calcuateCostAndTimeOfDeliveries(
        baseDeliveryCost: Double,
        packages: [PackageWithOffer],
        numberOfVehicles: Int,
        vehicleSpec: VehicleSpecification
    ) -> [DeliveryCostAndTime] {
        let costOfDeliveries = calculateCostOfDeliveries(baseDeliveryCost: baseDeliveryCost, packages: packages)
        let packagesWithoutOffer = packages.map { $0.toPackageWithoutOffer() }
        let packageDeliveryTimes = deliveryTimeCalculator.estimateDeliveryTime(packages: packagesWithoutOffer, numberOfVehicles: numberOfVehicles, vehicleSpecification: vehicleSpec)

        var costAndTimeOfDeliveries: [DeliveryCostAndTime] = []
        let costAndTimeZipped = zip(costOfDeliveries, packageDeliveryTimes)
        for (deliverCost, deliveryTime) in costAndTimeZipped {
            let deliveryCostAndTime = DeliveryCostAndTime(
                packageId: deliverCost.packageId,
                discount: deliverCost.discount.truncate(places: 2),
                totalCost: deliverCost.totalCost,
                estimatedDeliveryTime: deliveryTime.deliveryTimeInHr
            )
            costAndTimeOfDeliveries.append(deliveryCostAndTime)
        }
        return costAndTimeOfDeliveries
    }
}

extension PackageWithOffer {
    func toPackageWithoutOffer() -> Package {
        Package(id: id, weightInKg: weightInKg, distanceToDestination: distanceToDestination)
    }
}
struct DeliveryCostAndTime: Equatable {
    let packageId: String
    let discount: Double
    let totalCost: Double
    let estimatedDeliveryTime: String
}
