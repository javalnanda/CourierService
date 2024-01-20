import XCTest
@testable import CourierService

final class DeliveryCostCalulatorTests: XCTestCase {

    func test_totalEstimatedCostWithInvalidOffer_returns_validCost() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let package = PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "Invalid")
        let deliveryCost = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedDeliveryCost = DeliveryCost(packageId: "PKG1", discount: 0.0, totalCost: 175.0)
        XCTAssertEqual(expectedDeliveryCost, deliveryCost)
    }

    func test_totalEstimatedCostWithValidOfferCriteria_returns_totalCost_afterApplyingDiscount() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let package = PackageWithOffer(id: "PKG3", weightInKg: 10.0, distanceToDestination: 100.0, offerCode: "OFR003")
        let deliveryCost = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedDeliveryCost = DeliveryCost(packageId: "PKG3", discount: 35.0, totalCost: 665.0)
        XCTAssertEqual(expectedDeliveryCost, deliveryCost)
    }

    func test_totalEstimatedCostWithValidOfferCode_notMeetingOfferCriteria_returns_totalCost_withoutDiscount() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let package = PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "OFR001")
        let deliveryCost = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedDeliveryCost = DeliveryCost(packageId: "PKG1", discount: 0.0, totalCost: 175.0)
        XCTAssertEqual(expectedDeliveryCost, deliveryCost)
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
        let deliveryCost = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost, package: package)

        let expectedDeliveryCost = DeliveryCost(packageId: "PKG1", discount: 29.0, totalCost: 1421.0)
        XCTAssertEqual(expectedDeliveryCost, deliveryCost)
    }

    private func makeSut(offerService: OfferService = MockOfferStore()) -> DeliveryCostCalculator {
        return DeliveryCostCalculator(offerService: offerService)
    }
}
