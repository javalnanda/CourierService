import XCTest
@testable import CourierService

final class CourierDeliveryTests: XCTestCase {

    func test_costOfDeliveries_withInvalidOfferCode_returnsValidOutput() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let packages = [
            PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "Invalid"),
            PackageWithOffer(id: "PKG2", weightInKg: 15.0, distanceToDestination: 5.0, offerCode: "Invalid")
        ]
        let estimatedCostOfDeliveries = sut.calculateCostOfDeliveries(baseDeliveryCost: baseDeliveryCost, packages: packages)

        let expectedCostOfDeliveries = [
            DeliveryCost(packageId: "PKG1", discount: 0, totalCost: 175),
            DeliveryCost(packageId: "PKG2", discount: 0, totalCost: 275),
        ]
        XCTAssertEqual(estimatedCostOfDeliveries, expectedCostOfDeliveries)
    }

    func test_costOfDeliveries_withValidOfferCode_returns_totalCost_withDiscount_if_applicable() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let packages = [
            PackageWithOffer(id: "PKG1", weightInKg: 5.0, distanceToDestination: 5.0, offerCode: "OFR001"),
            PackageWithOffer(id: "PKG2", weightInKg: 15.0, distanceToDestination: 5.0, offerCode: "OFR002"),
            PackageWithOffer(id: "PKG3", weightInKg: 10.0, distanceToDestination: 100.0, offerCode: "OFR003")
        ]
        let estimatedCostOfDeliveries = sut.calculateCostOfDeliveries(baseDeliveryCost: baseDeliveryCost, packages: packages)

        let expectedCostOfDeliveries = [
            DeliveryCost(packageId: "PKG1", discount: 0, totalCost: 175),
            DeliveryCost(packageId: "PKG2", discount: 0, totalCost: 275),
            DeliveryCost(packageId: "PKG3", discount: 35, totalCost: 665),
        ]
        XCTAssertEqual(estimatedCostOfDeliveries, expectedCostOfDeliveries)
    }

    func test_calculateTimeOfDeliveries_returns_valid_deliveryCostAndTime() {
        let sut = makeSut()

        let baseDeliveryCost = 100.0
        let noOfVehicles = 2
        let vehicleSpec = VehicleSpecification(maxSpeed: 70, maxWeightCapacity: 200)
        let packagesWithOffer = [
            PackageWithOffer(id: "PKG1", weightInKg: 50.0, distanceToDestination: 30.0, offerCode: "OFR001"),
            PackageWithOffer(id: "PKG2", weightInKg: 75.0, distanceToDestination: 125.0, offerCode: "OFR0008"),
            PackageWithOffer(id: "PKG3", weightInKg: 175.0, distanceToDestination: 100.0, offerCode: "OFFR003"),
            PackageWithOffer(id: "PKG4", weightInKg: 110.0, distanceToDestination: 60.0, offerCode: "OFR002"),
            PackageWithOffer(id: "PKG5", weightInKg: 155.0, distanceToDestination: 95.0, offerCode: "")
        ]
        let costAndTimeOfDeliveries = sut.calcuateCostAndTimeOfDeliveries(baseDeliveryCost: baseDeliveryCost, packages: packagesWithOffer, numberOfVehicles: noOfVehicles, vehicleSpec: vehicleSpec)

        let expectedCostAndTimeOfDeliveries = [
            DeliveryCostAndTime(packageId: "PKG1", discount: 0.0, totalCost: 750.0, estimatedDeliveryTime: "3.98"),
            DeliveryCostAndTime(packageId: "PKG2", discount: 0.0, totalCost: 1475.0, estimatedDeliveryTime: "1.78"),
            DeliveryCostAndTime(packageId: "PKG3", discount: 0.0, totalCost: 2350.0, estimatedDeliveryTime: "1.42"),
            DeliveryCostAndTime(packageId: "PKG4", discount: 105.0, totalCost: 1395.0, estimatedDeliveryTime: "0.85"),
            DeliveryCostAndTime(packageId: "PKG5", discount: 0.0, totalCost: 2125.0, estimatedDeliveryTime: "4.19"),
        ]
        XCTAssertEqual(expectedCostAndTimeOfDeliveries, costAndTimeOfDeliveries)
    }

    private func makeSut() -> CourierDelivery {
        let deliveryCostCalculator = DeliveryCostCalculator(offerService: MockOfferStore())
        let deliveryTimeCalculator = DeliveryTimeCalculator()
        return CourierDelivery(deliveryCostCalculator: deliveryCostCalculator, deliveryTimeCalculator: deliveryTimeCalculator)
    }
}
