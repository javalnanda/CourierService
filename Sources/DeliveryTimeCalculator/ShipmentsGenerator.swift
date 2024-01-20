struct ShipmentsGenerator {
    func generateShipments(
        packages: [Package],
        numberOfVehicles: Int,
        vehicleSpec: VehicleSpecification
    ) -> [Shipment] {
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
        let uniqueSortedShipments = removeDuplicatePackageFromLowerWeightedShipment(
            shipments: shipments,
            vehicleSpec: vehicleSpec
        )
        return uniqueSortedShipments
    }

    private func removeDuplicatePackageFromLowerWeightedShipment(
        shipments: [Shipment],
        vehicleSpec: VehicleSpecification
    ) -> [Shipment] {
        var packageSelected: [Package] = []
        var uniqueShipments: [Shipment] = []
        let sortedShipments = sortByWeightAndDistance(shipments: shipments)
        for shipment in sortedShipments {
            var updatedPackages: [Package] = []
            for package in shipment.packages {
                if !packageSelected.contains(package) {
                    updatedPackages.append(package)
                    packageSelected.append(package)
                }
            }
            if !updatedPackages.isEmpty {
                let updatedShipment = createShipment(
                    from: updatedPackages,
                    maxSpeed: vehicleSpec.maxSpeed
                )
                uniqueShipments.append(updatedShipment)
            }
        }
        let uniqueSortedShipments = sortByWeightAndDistance(shipments: uniqueShipments)
        return uniqueSortedShipments
    }

    private func sortByWeightAndDistance(shipments: [Shipment]) -> [Shipment] {
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
        let maxDeliveryTime = packages.sorted {
            $0.distanceToDestination > $1.distanceToDestination
        }[0].distanceToDestination / maxSpeed
        let shortestDistance = packages.sorted {
            $0.distanceToDestination < $1.distanceToDestination
        }[0].distanceToDestination
        return Shipment(
            packages: packages,
            totalWeight: totalWeight,
            maxDeliveryTime: maxDeliveryTime.truncate(places: 2),
            shortestDistance: shortestDistance
        )
    }
}

struct Shipment {
    let packages: [Package]
    let totalWeight: Double
    let maxDeliveryTime: Double
    let shortestDistance: Double
}
