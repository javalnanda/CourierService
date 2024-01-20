import XCTest
@testable import CourierService

final class DeliveryCostCalulatorTests: XCTestCase {

    func test_totalEstimatedCostWithInvalidOffer_returns_validCost() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let package = PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "Invalid")
        let (totalEstimatedCost, discount) = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedEstimatedCost = 175.0
        let expectedDiscount = 0.0
        XCTAssertEqual(expectedEstimatedCost, totalEstimatedCost)
        XCTAssertEqual(expectedDiscount, discount)
    }

    func test_totalEstimatedCostWithValidOfferCriteria_returns_totalCost_afterApplyingDiscount() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let package = PackageWithOffer(id: "PKG3", weightInKg: 10.0, distanceToDestination: 100.0, offerCode: "OFR003")
        let (totalEstimatedCost, discount) = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedEstimatedCost = 665.0
        let expectedDiscount = 35.0
        XCTAssertEqual(expectedEstimatedCost, totalEstimatedCost)
        XCTAssertEqual(expectedDiscount, discount)
    }

    func test_totalEstimatedCostWithValidOfferCode_notMeetingOfferCriteria_returns_totalCost_withoutDiscount() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let package = PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "OFR001")
        let (totalEstimatedCost, discount) = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedEstimatedCost = 175.0
        let expectedDiscount = 0.0
        XCTAssertEqual(expectedEstimatedCost, totalEstimatedCost)
        XCTAssertEqual(expectedDiscount, discount)
    }

    func test_totalEstimatedCost_withPackage_meeting_criteriaOfNewlyAddedOfferCode_returns_appliesCorrectDiscount() {
        let offerStore = MockOfferStore()
        let sut = makeSut(offerService: offerStore)
        let newOffer = Offer(
            code: "OFR004",
            discountInPercentage: 2,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: 100, max: 300),
                weight: Offer.Range(min: 50, max: 200)
            )
        )
        offerStore.add(offer: newOffer)

        let baseDeliveryCost = 100.0
        let package = PackageWithOffer(id: "PKG1", weightInKg: 60.0, distanceToDestination: 150, offerCode: "OFR004")
        let (totalEstimatedCost, discount) = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedEstimatedCost = 1421.0
        let expectedDiscount = 29.0
        XCTAssertEqual(expectedEstimatedCost, totalEstimatedCost)
        XCTAssertEqual(expectedDiscount, discount)
    }

    private func makeSut(offerService: OfferService = MockOfferStore()) -> DeliveryCostCalculator {
        return DeliveryCostCalculator(offerService: offerService)
    }
}
