import Foundation

protocol DeliveryTimeCalculatorService {
    func estimateDeliveryTime(
        packages: [Package],
        numberOfVehicles: Int,
        vehicleSpecification: VehicleSpecification
    ) -> [PackageDeliveryTime]
}

struct DeliveryTimeCalculator: DeliveryTimeCalculatorService {
    private let shipmentsGenerator = ShipmentsGenerator()

    func estimateDeliveryTime(
        packages: [Package],
        numberOfVehicles: Int,
        vehicleSpecification: VehicleSpecification
    ) -> [PackageDeliveryTime] {
        let totalVehicles: [Vehicle] = Array(
            repeating: Vehicle(
                spec: vehicleSpecification,
                currentTime: 0.0
            ),
            count: numberOfVehicles
        )
        let packagesEstimatedDeliveryTime: [PackageDeliveryTime] = estimateTimeForPackages(
            packages: packages,
            vehicles: totalVehicles
        )
        return packagesEstimatedDeliveryTime
    }

    private func estimateTimeForPackages(packages: [Package], vehicles: [Vehicle]) -> [PackageDeliveryTime] {
        var availableVehicles = vehicles
        var remainingPackages = packages
        var packagesEstimatedDeliveryTime: [PackageDeliveryTime] = []
        while !remainingPackages.isEmpty {
            if !availableVehicles.isEmpty {
                let nextShipment = shipmentsGenerator.getNextShipment(
                    packages: remainingPackages,
                    vehicleSpec: VehicleSpecification(
                        maxSpeed: vehicles[0].spec.maxSpeed,
                        maxWeightCapacity: vehicles[0].spec.maxWeightCapacity
                    )
                )
                remainingPackages = remainingPackages.filter { !nextShipment.packages.contains($0) }
                let (packagesDeliveryTime, updatedVehicle) = deliverShipmentAndUpdateVehicle(
                    shipment: nextShipment,
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

    private func deliverShipmentAndUpdateVehicle(
        shipment: Shipment,
        vehicle: Vehicle
    ) -> ([PackageDeliveryTime], Vehicle) {
        var packagesDeliveryTime: [PackageDeliveryTime] = []
        for package in shipment.packages {
            let deliveryTime = (package.distanceToDestination / vehicle.spec.maxSpeed) + vehicle.currentTime
            packagesDeliveryTime.append(
                PackageDeliveryTime(
                    id: package.id,
                    deliveryTimeInHr: deliveryTime.toString()
                )
            )
        }

        let updatedVehicle = updateVehicleTimeAfterDeliveringShipment(vehicle: vehicle, shipment: shipment)
        return (packagesDeliveryTime, updatedVehicle)
    }

    private func updateVehicleTimeAfterDeliveringShipment(
        vehicle: Vehicle,
        shipment: Shipment
    ) -> Vehicle {
        let updatedVehicleTime = vehicle.currentTime + (shipment.maxDeliveryTime * 2).truncate(places: 2)
        let updatedVehicle = Vehicle(
            spec: vehicle.spec,
            currentTime: updatedVehicleTime.truncate(places: 2)
        )
        return updatedVehicle
    }
}

private struct Vehicle {
    let spec: VehicleSpecification
    let currentTime: Double
}
