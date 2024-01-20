import Foundation

struct DeliveryTimeCalculator {
    private let shipmentsGenerator = ShipmentsGenerator()

    func estimateDeliveryTime(
        packages: [Package],
        numberOfVehicles: Int,
        vehicleSpecification: VehicleSpecification
    ) -> [PackageDeliveryTime] {
        let totalShipments = shipmentsGenerator.generateShipments(
            packages: packages,
            numberOfVehicles: numberOfVehicles,
            vehicleSpec: vehicleSpecification
        )
        let totalVehicles: [Vehicle] = Array(
            repeating: Vehicle(
                spec: vehicleSpecification,
                currentTime: 0.0
            ),
            count: numberOfVehicles
        )
        let packagesEstimatedDeliveryTime: [PackageDeliveryTime] = estimateTimeForShipments(
            shipments: totalShipments,
            vehicles: totalVehicles
        )
        return packagesEstimatedDeliveryTime
    }

    private func estimateTimeForShipments(shipments: [Shipment], vehicles: [Vehicle]) -> [PackageDeliveryTime] {
        var availableVehicles = vehicles
        var remainingShipments = shipments
        var packagesEstimatedDeliveryTime: [PackageDeliveryTime] = []
        while remainingShipments.count > 0 {
            if availableVehicles.count > 0 {
                let (packagesDeliveryTime, updatedVehicle) = deliverShipmentAndUpdateVehicle(
                    shipment: remainingShipments.removeFirst(),
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
