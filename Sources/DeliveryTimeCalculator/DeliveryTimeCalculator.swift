import Foundation

struct PackageDeliveryTime: Equatable {
    let id: String
    let deliveryTimeInHr: String
}

struct VehicleSpecification {
    let maxSpeed: Double
    let maxWeightCapacity: Double
}

struct Shipment {
    let packages: [Package]
    let totalWeight: Double
    let maxDeliveryTime: Double
    let shortestDistance: Double
}

private struct Vehicle {
    let id: String
    let spec: VehicleSpecification
    let currentTime: Double
}

struct DeliveryTimeCalculator {
    func estimateDeliveryTime(
        packages: [Package],
        numberOfVehicles: Int,
        vehicleSpecification: VehicleSpecification
    ) -> [PackageDeliveryTime] {

        var shipments = shipments(packages: packages, numberOfVehicles: numberOfVehicles, vehicleSpec: vehicleSpecification)
        var availableVehicles: [Vehicle] = getAvailableVehicles(noOfVehicles: numberOfVehicles, spec: vehicleSpecification)
        var packagesEstimatedDeliveryTime: [PackageDeliveryTime] = []
        while shipments.count > 0 {
            if availableVehicles.count > 0 {
                let (packagesDeliveryTime, updatedVehicle) = deliver(
                    shipment: shipments.removeFirst(),
                    vehicle: availableVehicles.removeFirst()
                )
                packagesEstimatedDeliveryTime.append(contentsOf: packagesDeliveryTime)
                availableVehicles.append(updatedVehicle)
                availableVehicles.sort { $0.currentTime < $1.currentTime }
            }
        }
        packagesEstimatedDeliveryTime.sort { $0.id < $1.id }
        return packagesEstimatedDeliveryTime
    }

    private func getAvailableVehicles(noOfVehicles: Int, spec: VehicleSpecification) -> [Vehicle] {
        var vehicles: [Vehicle] = []
        for i in 1...noOfVehicles {
            vehicles.append(Vehicle(id: "\(i)", spec: spec, currentTime: 0))
        }
        return vehicles
    }

    private func deliver(shipment: Shipment, vehicle: Vehicle) -> ([PackageDeliveryTime], Vehicle) {
        print("\n\nVehicle:\(vehicle) delivering shipment:\(shipment)\n\n")
        var packagesDeliveryTime: [PackageDeliveryTime] = []
        for package in shipment.packages {
            let deliveryTime = (package.distanceToDestination / vehicle.spec.maxSpeed) + vehicle.currentTime
            packagesDeliveryTime.append(PackageDeliveryTime(id: package.id, deliveryTimeInHr: deliveryTime.toString()))
        }
        let updatedVehicleTime = vehicle.currentTime + (shipment.maxDeliveryTime * 2).truncate(places: 2)
        let updatedVehicle = Vehicle(id: vehicle.id, spec: vehicle.spec, currentTime: updatedVehicleTime.truncate(places: 2))
        print("UpdatedVehicle:\(updatedVehicle)")
        return (packagesDeliveryTime, updatedVehicle)
    }

    private func shipments(packages: [Package], numberOfVehicles: Int, vehicleSpec: VehicleSpecification) -> [Shipment] {
        let maxCapacity = vehicleSpec.maxWeightCapacity
        var shipments: [Shipment] = []
        for i in 0..<packages.count {
            let currentReferencePackage = packages[i]
            var localMaxWeight = currentReferencePackage.weightInKg
            var currentBestCombination: [Package] = [currentReferencePackage]

            for j in i + 1..<packages.count {
                let nextReferencePackage = packages[j]
                let totalWeightWithCurrentCombination =
                currentBestCombination.reduce(0) { $0 + $1.weightInKg } + nextReferencePackage.weightInKg
                if totalWeightWithCurrentCombination < maxCapacity &&
                    totalWeightWithCurrentCombination > localMaxWeight {
                    localMaxWeight = totalWeightWithCurrentCombination
                    currentBestCombination.append(nextReferencePackage)
                } else {
                    let weightOfPair = nextReferencePackage.weightInKg + currentReferencePackage.weightInKg
                    if weightOfPair < maxCapacity && weightOfPair > localMaxWeight {
                        localMaxWeight = weightOfPair
                        currentBestCombination = [currentReferencePackage, nextReferencePackage]
                    }
                }
            }

            let shipment = createShipment(from: currentBestCombination, maxSpeed: vehicleSpec.maxSpeed)
            shipments.append(shipment)
        }

        let sortedShipments = sort(shipments: shipments)

        var packageSelected: [Package] = []
        var uniqueShipments: [Shipment] = []

        for shipment in sortedShipments {
            var updatedPackages: [Package] = []
            for package in shipment.packages {
                if !packageSelected.contains(package) {
                    updatedPackages.append(package)
                    packageSelected.append(package)
                }
            }
            if !updatedPackages.isEmpty {
                let updatedShipment = createShipment(from: updatedPackages, maxSpeed: vehicleSpec.maxSpeed)
                uniqueShipments.append(updatedShipment)
            }
        }

        let uniqueSortedShipments = sort(shipments: uniqueShipments)
        return uniqueSortedShipments
    }

    private func sort(shipments: [Shipment]) -> [Shipment] {
        return shipments.sorted {
            if $0.totalWeight == $1.totalWeight {
                $0.shortestDistance < $1.shortestDistance
            } else {
                $0.totalWeight > $1.totalWeight
            }
        }
    }

    private func createShipment(from packages: [Package], maxSpeed: Double) -> Shipment {
        let totalWeight = packages.reduce(0) { $0 + $1.weightInKg }
        let maxDeliveryTime = packages.sorted { $0.distanceToDestination > $1.distanceToDestination }[0].distanceToDestination / maxSpeed
        let shortestDistance = packages.sorted { $0.distanceToDestination < $1.distanceToDestination }[0].distanceToDestination
        return Shipment(
            packages: packages,
            totalWeight: totalWeight,
            maxDeliveryTime: maxDeliveryTime.truncate(places: 2),
            shortestDistance: shortestDistance
        )
    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }

    func toString(decimalPlaces: Int = 2) -> String {
        let truncatedDouble = self.truncate(places: decimalPlaces)
        return String(format: "%.\(decimalPlaces)f", truncatedDouble)
    }
}
