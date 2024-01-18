struct Offer {
    let code: String
    let discountInPercentage: Double
    let criteria: Criteria

    struct Criteria {
        let distance: Range
        let weight: Range
    }

    struct Range {
        let min: Double
        let max: Double
    }
}

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
        let deliveryCostWithoutDiscount = baseDeliveryCost + (package.weightInKg * 10) + (package.distanceToDestination * 5)
        let discountPercentage = discountPercentageForPackage(package: package)
        let discountToApply = deliveryCostWithoutDiscount * (discountPercentage/100)
        let totalEstimatedPrice = deliveryCostWithoutDiscount - discountToApply
        return totalEstimatedPrice
    }

    private func discountPercentageForPackage(package: Package) -> Double {
        guard let validOffer = offers.first(where: { $0.code == package.offerCode }) else {
            return 0.0
        }

        if package.distanceToDestination >= validOffer.criteria.distance.min && 
            package.distanceToDestination <= validOffer.criteria.distance.max &&
            package.weightInKg >= validOffer.criteria.weight.min &&
            package.weightInKg <= validOffer.criteria.weight.max {
            return validOffer.discountInPercentage
        }
        return 0
    }
}
