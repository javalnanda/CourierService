struct DeliveryCostCalculator {
    private let offers: [Offer] = [
        Offer(
            code: "OFR001",
            discountInPercentage: 10,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 0, max: 199),
                weight: Offer.Range(min: 70, max: 200)
            )
        ),
        Offer(
            code: "OFR002",
            discountInPercentage: 7,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 50, max: 150),
                weight: Offer.Range(min: 100, max: 250)
            )
        ),
        Offer(
            code: "OFR003",
            discountInPercentage: 5,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 50, max: 250),
                weight: Offer.Range(min: 10, max: 150)
            )
        ),
    ]

    func calculateTotalEstimatedCost(baseDeliveryCost: Double, package: Package) -> Double {
        let deliveryCostWithoutDiscount = calculateDeliveryCostWithoutDiscount(baseDeliveryCost: baseDeliveryCost, package: package)
        let discountPercentage = discountPercentageForPackage(package: package)
        let discountToApply = deliveryCostWithoutDiscount * (discountPercentage/100)
        let totalEstimatedPrice = deliveryCostWithoutDiscount - discountToApply
        return totalEstimatedPrice
    }
    
    private func calculateDeliveryCostWithoutDiscount(baseDeliveryCost: Double, package: Package) -> Double {
        baseDeliveryCost + (package.weightInKg * 10) + (package.distanceToDestination * 5)
    }

    private func discountPercentageForPackage(package: Package) -> Double {
        guard let validOffer = offers.first(where: { $0.code == package.offerCode }) else {
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
