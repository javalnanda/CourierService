import XCTest
@testable import CourierService

final class DeliveryCostCalulatorTests: XCTestCase {
    
    func test_totalEstimatedCostWithInvalidOffer_returns_validCost() {
        let sut = DeliveryCostCalculator()

        let baseDeliveryCost = 100.0
        let package = Package(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "Invalid")
        let totalEstimatedCost = sut.calculateTotalEstimatedCost(baseDeliveryCost: baseDeliveryCost,package: package)

        let expectedEstimatedCost = 175.0
        XCTAssertEqual(expectedEstimatedCost, totalEstimatedCost)
    }
}
