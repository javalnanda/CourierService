import XCTest
@testable import CourierService

final class DeliveryTimeCalculatorTests: XCTestCase {

    func test_estimatedDeliveryTime() {
        let sut = DeliveryTimeCalculator()

        let packages = [
            Package(id: "PKG1", weightInKg: 50.0, distanceToDestination: 30.0, offerCode: ""),
            Package(id: "PKG2", weightInKg: 75.0, distanceToDestination: 125.0, offerCode: ""),
            Package(id: "PKG3", weightInKg: 175.0, distanceToDestination: 100.0, offerCode: ""),
            Package(id: "PKG4", weightInKg: 110.0, distanceToDestination: 60.0, offerCode: ""),
            Package(id: "PKG5", weightInKg: 155.0, distanceToDestination: 95.0, offerCode: "")
        ]
        let numberOfVehicles = 2
        let vehicleSpec = VehicleSpecification(maxSpeed: 70.0, maxWeightCapacity: 200.0)
        let estimatedDeliveryTimeForPackages = sut.estimateDeliveryTime(
            packages: packages,
            numberOfVehicles: numberOfVehicles,
            vehicleSpecification: vehicleSpec
        )

        let expectedDeliveryTimeForPackages = [
            PackageDeliveryTime(id: "PKG1", deliveryTimeInHr: "3.98"),
            PackageDeliveryTime(id: "PKG2", deliveryTimeInHr: "1.78"),
            PackageDeliveryTime(id: "PKG3", deliveryTimeInHr: "1.42"),
            PackageDeliveryTime(id: "PKG4", deliveryTimeInHr: "0.85"),
            PackageDeliveryTime(id: "PKG5", deliveryTimeInHr: "4.19")
        ]
        XCTAssertEqual(estimatedDeliveryTimeForPackages, expectedDeliveryTimeForPackages)
    }
}
