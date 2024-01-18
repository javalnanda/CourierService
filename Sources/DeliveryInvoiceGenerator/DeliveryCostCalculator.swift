struct DeliveryCostCalculator {
    let offerStore: OfferStore

    func calculateTotalEstimatedCost(
        baseDeliveryCost: Double,
        package: Package
    ) -> (totalCost: Double, discount: Double) {
        let deliveryCostWithoutDiscount = calculateDeliveryCostWithoutDiscount(
            baseDeliveryCost: baseDeliveryCost,
            package: package
        )
        let discountPercentage = discountPercentageForPackage(package: package)
        let discountToApply = deliveryCostWithoutDiscount * (discountPercentage/100)
        let totalEstimatedPrice = deliveryCostWithoutDiscount - discountToApply
        return (totalEstimatedPrice, discountToApply)
    }
    
    private func calculateDeliveryCostWithoutDiscount(
        baseDeliveryCost: Double,
        package: Package
    ) -> Double {
        baseDeliveryCost + (package.weightInKg * 10) + (package.distanceToDestination * 5)
    }

    private func discountPercentageForPackage(package: Package) -> Double {
        guard let validOffer = offerStore.getOfferBy(code: package.offerCode) else {
            return 0.0
        }

        if packageMeetsOfferCriteria(offer: validOffer, package: package) {
            return validOffer.discountInPercentage
        }
        return 0
    }

    private func packageMeetsOfferCriteria(offer: Offer, package: Package) -> Bool {
        package.distanceToDestination >= offer.criteria.distance.min &&
        package.distanceToDestination <= offer.criteria.distance.max &&
        package.weightInKg >= offer.criteria.weight.min &&
        package.weightInKg <= offer.criteria.weight.max
    }
}
