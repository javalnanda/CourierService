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

    func test_generateInvoices_withValidOfferCode_returns_totalCost_withDiscount_if_applicable() {
        let deliveryCostCalculator = DeliveryCostCalculator()
        let sut = DeliveryInvoiceGenerator(deliveryCostCalculator: deliveryCostCalculator)

        let baseDeliveryCost = 100.0
        let packages = [
            Package(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "OFR001"),
            Package(id: "PKG2", weightInKg: 15.0, distanceToDestination: 5.0, offerCode: "OFR002"),
            Package(id: "PKG3", weightInKg: 10.0, distanceToDestination: 100.0, offerCode: "OFR003")
        ]
        let generatedInvoices = sut.generateInvoices(baseDeliveryCost: baseDeliveryCost, packages: packages)

        let expectedInvoices = [
            DeliveryInvoice(packageId: "PKG1", discount: 0, totalCost: 175),
            DeliveryInvoice(packageId: "PKG2", discount: 0, totalCost: 275),
            DeliveryInvoice(packageId: "PKG3", discount: 35, totalCost: 665),
        ]
        XCTAssertEqual(generatedInvoices, expectedInvoices)
    }
}
