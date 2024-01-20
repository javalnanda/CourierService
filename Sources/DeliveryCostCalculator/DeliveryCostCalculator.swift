struct DeliveryCostCalculator {
    let offerService: OfferService

    func calculateTotalEstimatedCost(
        baseDeliveryCost: Double,
        package: PackageWithOffer
    ) -> (totalCost: Double, discount: Double) {
        let deliveryCostWithoutDiscount = calculateDeliveryCostWithoutDiscount(
            baseDeliveryCost: baseDeliveryCost,
            package: package
        )
        let discountPercentage = discountPercentageForPackage(package: package)
        let discountToApply = deliveryCostWithoutDiscount * (discountPercentage / 100)
        let totalEstimatedPrice = deliveryCostWithoutDiscount - discountToApply
        return (totalEstimatedPrice, discountToApply)
    }

    private func calculateDeliveryCostWithoutDiscount(
        baseDeliveryCost: Double,
        package: PackageWithOffer
    ) -> Double {
        baseDeliveryCost + (package.weightInKg * 10) + (package.distanceToDestination * 5)
    }

    private func discountPercentageForPackage(package: PackageWithOffer) -> Double {
        guard let validOffer = offerService.getOfferBy(code: package.offerCode) else {
            return 0.0
        }

        if packageMeetsOfferCriteria(offer: validOffer, package: package) {
            return validOffer.discountInPercentage
        }
        return 0
    }

    private func packageMeetsOfferCriteria(offer: Offer, package: PackageWithOffer) -> Bool {
        package.distanceToDestination >= offer.criteria.distance.min &&
        package.distanceToDestination <= offer.criteria.distance.max &&
        package.weightInKg >= offer.criteria.weight.min &&
        package.weightInKg <= offer.criteria.weight.max
    }
}
