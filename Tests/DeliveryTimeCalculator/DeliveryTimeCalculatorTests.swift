import XCTest
@testable import CourierService

final class DeliveryTimeCalculatorTests: XCTestCase {

    func test_estimatedDeliveryTime_with_fivePackages_twoVehicles() {
        let sut = DeliveryTimeCalculator()

        let packages = [
            Package(id: "PKG1", weightInKg: 50.0, distanceToDestination: 30.0),
            Package(id: "PKG2", weightInKg: 75.0, distanceToDestination: 125.0),
            Package(id: "PKG3", weightInKg: 175.0, distanceToDestination: 100.0),
            Package(id: "PKG4", weightInKg: 110.0, distanceToDestination: 60.0),
            Package(id: "PKG5", weightInKg: 155.0, distanceToDestination: 95.0)
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

    func test_estimatedDeliveryTime_with_eightPackages_threeVehicles() {
        let sut = DeliveryTimeCalculator()

        let packages = [
            Package(id: "PKG1", weightInKg: 40.0, distanceToDestination: 100.0),
            Package(id: "PKG2", weightInKg: 150.0, distanceToDestination: 60.0),
            Package(id: "PKG3", weightInKg: 130.0, distanceToDestination: 100.0),
            Package(id: "PKG4", weightInKg: 50.0, distanceToDestination: 150.0),
            Package(id: "PKG5", weightInKg: 60.0, distanceToDestination: 120.0),
            Package(id: "PKG6", weightInKg: 70.0, distanceToDestination: 100.0),
            Package(id: "PKG7", weightInKg: 80.0, distanceToDestination: 140.0),
            Package(id: "PKG8", weightInKg: 90.0, distanceToDestination: 180.0),
        ]
        let numberOfVehicles = 3
        let vehicleSpec = VehicleSpecification(maxSpeed: 80.0, maxWeightCapacity: 200.0)
        let estimatedDeliveryTimeForPackages = sut.estimateDeliveryTime(
            packages: packages,
            numberOfVehicles: numberOfVehicles,
            vehicleSpecification: vehicleSpec
        )

        let expectedDeliveryTimeForPackages = [
            PackageDeliveryTime(id: "PKG1", deliveryTimeInHr: "1.25"),
            PackageDeliveryTime(id: "PKG2", deliveryTimeInHr: "0.75"),
            PackageDeliveryTime(id: "PKG3", deliveryTimeInHr: "1.25"),
            PackageDeliveryTime(id: "PKG4", deliveryTimeInHr: "1.87"),
            PackageDeliveryTime(id: "PKG5", deliveryTimeInHr: "1.50"),
            PackageDeliveryTime(id: "PKG6", deliveryTimeInHr: "1.25"),
            PackageDeliveryTime(id: "PKG7", deliveryTimeInHr: "1.75"),
            PackageDeliveryTime(id: "PKG8", deliveryTimeInHr: "4.75"),
        ]
        XCTAssertEqual(estimatedDeliveryTimeForPackages, expectedDeliveryTimeForPackages)
    }
}
