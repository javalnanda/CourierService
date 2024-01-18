struct DeliveryCostCalculator {
    func calculateTotalEstimatedCost(baseDeliveryCost: Double, package: Package) -> Double {
        return baseDeliveryCost + (package.weightInKg * 10) + (package.distanceToDestination * 5)
    }
}
