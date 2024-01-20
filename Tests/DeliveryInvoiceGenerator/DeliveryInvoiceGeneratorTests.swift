import XCTest
@testable import CourierService

final class DeliveryCostGeneratorTests: XCTestCase {

    func test_generateInvoices_withInvalidOfferCode_returnsValidOutput() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let packages = [
            PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "Invalid"),
            PackageWithOffer(id: "PKG2", weightInKg: 15.0, distanceToDestination: 5.0, offerCode: "Invalid")
        ]
        let estimatedCostOfDeliveries = sut.generateInvoices(baseDeliveryCost: baseDeliveryCost, packages: packages)

        let expectedCostOfDeliveries = [
            DeliveryCost(packageId: "PKG1", discount: 0, totalCost: 175),
            DeliveryCost(packageId: "PKG2", discount: 0, totalCost: 275),
        ]
        XCTAssertEqual(estimatedCostOfDeliveries, expectedCostOfDeliveries)
    }

    func test_generateInvoices_withValidOfferCode_returns_totalCost_withDiscount_if_applicable() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let packages = [
            PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "OFR001"),
            PackageWithOffer(id: "PKG2", weightInKg: 15.0, distanceToDestination: 5.0, offerCode: "OFR002"),
            PackageWithOffer(id: "PKG3", weightInKg: 10.0, distanceToDestination: 100.0, offerCode: "OFR003")
        ]
        let estimatedCostOfDeliveries = sut.generateInvoices(baseDeliveryCost: baseDeliveryCost, packages: packages)

        let expectedCostOfDeliveries = [
            DeliveryCost(packageId: "PKG1", discount: 0, totalCost: 175),
            DeliveryCost(packageId: "PKG2", discount: 0, totalCost: 275),
            DeliveryCost(packageId: "PKG3", discount: 35, totalCost: 665),
        ]
        XCTAssertEqual(estimatedCostOfDeliveries, expectedCostOfDeliveries)
    }

    private func makeSut() -> DeliveryInvoiceGenerator {
        let deliveryCostCalculator = DeliveryCostCalculator(offerService: MockOfferStore())
        return DeliveryInvoiceGenerator(deliveryCostCalculator: deliveryCostCalculator)
    }
}
