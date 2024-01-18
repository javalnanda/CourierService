import XCTest
@testable import CourierService

final class DeliveryInvoiceGeneratorTests: XCTestCase {

    func test_generateInvoices_withInvalidOfferCode_returnsValidOutput() {
        let deliveryCostCalculator = DeliveryCostCalculator()
        let sut = DeliveryInvoiceGenerator(deliveryCostCalculator: deliveryCostCalculator)

        let baseDeliveryCost = 100.0
        let packages = [
            Package(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "Invalid"),
            Package(id: "PKG2", weightInKg: 15.0, distanceToDestination: 5.0, offerCode: "Invalid")
        ]
        let generatedInvoices = sut.generateInvoices(baseDeliveryCost: baseDeliveryCost, packages: packages)

        let expectedInvoices = [
            DeliveryInvoice(packageId: "PKG1", discount: 0, totalCost: 175),
            DeliveryInvoice(packageId: "PKG2", discount: 0, totalCost: 275),
        ]

        XCTAssertEqual(generatedInvoices, expectedInvoices)
    }
}
