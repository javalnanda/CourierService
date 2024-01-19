import XCTest
@testable import CourierService

final class OfferStoreTests: XCTestCase {
    func test_getAllOffers_returns_all_offers() {
        let sut = OfferStore()

        let offers = sut.getAllOffers()

        let expectedOffers = [
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
        XCTAssertEqual(expectedOffers, offers)
    }

    func test_getOffer_by_validCode_returns_validOffer() {
        let sut = OfferStore()

        let validOffer = sut.getOfferBy(code: "OFR001")

        let expectedOffer = Offer(
            code: "OFR001",
            discountInPercentage: 10,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 0, max: 199),
                weight: Offer.Range(min: 70, max: 200)
            )
        )
        XCTAssertEqual(expectedOffer, validOffer)
    }

    func test_getOffer_by_invalidCode_returns_nil() {
        let sut = OfferStore()

        XCTAssertNil(sut.getOfferBy(code: "Invalid"))
    }

    func test_addNewOffer_adds_offer_to_store() {
        let sut = OfferStore()

        let newOffer = Offer(
            code: "OFR004",
            discountInPercentage: 2,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 100, max: 300),
                weight: Offer.Range(min: 50, max: 200)
            )
        )
        sut.add(offer: newOffer)

        let offer4 = sut.getOfferBy(code: newOffer.code)
        XCTAssertEqual(newOffer, offer4)
    }

    func test_adding_duplicate_offer_does_not_add_offer_to_store() {
        let sut = OfferStore()

        let newOffer = Offer(
            code: "OFR001",
            discountInPercentage: 10,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 0, max: 199),
                weight: Offer.Range(min: 70, max: 200)
            )
        )
        sut.add(offer: newOffer)

        XCTAssertEqual(sut.getAllOffers().count, 3)
    }

    func test_getOffer_is_caseInsensitive() {
        let sut = OfferStore()

        let offer1 = sut.getOfferBy(code: "ofr001")

        let expectedOffer = Offer(
            code: "OFR001",
            discountInPercentage: 10,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 0, max: 199),
                weight: Offer.Range(min: 70, max: 200)
            )
        )
        XCTAssertEqual(expectedOffer, offer1)
    }

    func test_removeOffer_removes_offer() {
        let sut = OfferStore()
        let newOffer = Offer(
            code: "OFR004",
            discountInPercentage: 2,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 100, max: 300),
                weight: Offer.Range(min: 50, max: 200)
            )
        )
        sut.add(offer: newOffer)

        sut.removeOffer(code: "ofr004")

        XCTAssertNil(sut.getOfferBy(code: "ofr004"))
    }
}
