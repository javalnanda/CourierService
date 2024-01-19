@testable import CourierService

class MockOfferStore: OfferService {
    var offers = [
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

    func getAllOffers() -> [Offer] {
        return offers
    }

    func getOfferBy(code: String) -> Offer? {
        return offers.first(where: { $0.code == code })
    }

    func add(offer: Offer) {
        if !offers.contains(offer) {
            offers.append(offer)
        }
    }

    func removeOffer(code: String) {
        offers.removeAll { $0.code.uppercased() == code.uppercased() }
    }
}
