# CourierService

CourierService is a command line tool written in Swift for dealing with courier services. This tool solves following problems:

## **Problem 01**

### Total delivery cost estimation
Estimate the **total delivery cost** of each package with an offer code (if applicable).

```
Total Delivery Cost = Delivery Cost - Discount
```
Delivery Cost is calculated based on:
```
Delivery cost = Base Delivery Cost + (Package Total Weight * 10) + (Distance to Destination * 5)
```
Discount is calculated based on the criterias defined for each offer depending on the weight of the package and distance of the delivery. Only one offer can be applied to a package. Discount will not be provided if offer code is not valid/found/not applied. 
for e.g
|                       | Distance (km) | Weight (kg) |
|-----------------------|---------------|-------------|
| OFR001 (10% Discount) | < 200         | 70-200      |
| OFR002 (7% Discount)  | 50-150        | 100-250     |
| OFR003 (5% Discount)  | 50-250        | 10-150      |

Note: We should have an ability to add more offer codes.

#### Expected input format:

base_delivery_cost no_of_packges
pkg_id1 pkg_weight1_in_kg distance1_in_km offer_code1

#### Expected output format:

pkg_id1 discount1 total_cost1

#### Sample input
100 3
PKG1 5 5 OFR001
PKG2 15 5 OFR002
PKG3 10 100 OFR003

#### Sample output
PKG1 0 175
PKG2 0 275
PKG 35 665

## **Problem 02**

### Delivery Time Estimation

All these packages should be delivered to their destinations in the fleet of vehicles (N no. of vehicles) available for delivering the packages. 
Calculate the **estimated delivery time** for every package by **maximizing no. of packages in every shipment**.
#### Assumptions
- Each Vehicle has a limit (L) on maximum weight (kg) that it can carry.
- All Vehicles travel at the same speed (S km/hr) and in the same route. It is assumed that all the destinations
 can be covered in a single route.

#### Delivery Criteria
- Shipment should contain max packages vehicle can carry in a trip.
- We should prefer heavier packages when there are multiple shipments with the same no. of packages.
- If the weights are also the same, preference should be given to the shipment which can be delivered first.
- Vehicles always travel at the max speed. 
- Post package delivery, vehicle will return back to the source station with the same speed and will be available for another shipment.

#### Expected input format:

base_delivery_cost no_of_packges
pkg_id1 pkg_weight1_in_kg distance1_in_km offer_code1
....
no_of_vehicles max_speed max_carriable_weight

#### Expected output format:

pkg_id1 discount1 total_cost1 estimated_delivery_time1_in_hour

#### Sample input
100 5
PKG1 50 30 OFR001
PKG2 75 125 OFFR0008
PKG3 175 100 OFFR003
PKG4 110 60 OFR002
PKG5 155 95 NA
2 70 200

#### Sample output
PKG1 0 750 3.98
PKG2 0 1475 1.78
PKG3 0 2350 1.42
PKG4 105 1395 0.85
PKG5 0 2125 4.19

# Usage

#### Prerequisite

Make sure [Swift](https://www.swift.org/install/macos/) is installed

Built with swift-tools-version: 5.9

#### via command line
To run the app, enter following command in project's root folder:

```
swift run
```

To run tests, enter following command:

```
swift test
```

Installing the CourierService command line tool

To enable it to be run from anywhere on the command line, build the tool using the release configuration, and then move the compiled binary to `/usr/local/bin`:

```
swift build -c release
cd .build/release
cp -f CourierService /usr/local/bin/courierservice
```
Now you can run `courierservice` from anywhere on the command line

#### via Xcode
Open `Package.swift` file in Xcode.

Press ⌘ + R to run the app
Press ⌘ + U to run the tests

### About Project

- Core Module's business logic was built using TDD and the steps for it can be referred from the git history. 
- The names of modules/classes are not defined based on any specific architecture but are generalized based on responsibility and the code can be easily extracted further into different layers if required as the care is taken to keep low coupling.
- Public api's are part of Protocol/Interface allowing concrete implementation to be replaced by other implementation if needed.
- The Core module can be packaged in a different swift package exposing only public api for CourierDelivery encapsulating other details. Similary, DeliveryCostCalculator, DeiveryTimeCalculator, Offers can be separate packages exposing only public apis of their modules.
- OfferStore is used as an in-memory store. Swift's command line application cannot write to files in a binary and writing db/store to external directory would not be advisable for the current requirement.
- Working with `Double` results in some difference in calculation if we use floor/ceil/round hence a utility is used to truncate decimals to 2 places and store it as a string for final display

### Dependencies
Only required dependencies are used. Dependencies for beautification(for e.g Figlet) are not used.
- [SwiftCLI](https://github.com/jakeheis/SwiftCLI): For type-checked cli input prompts. Initially it was used for parsing sub-commands but later sub-commands were replaced with Question based menu to maintain command line session.
- [Table](https://github.com/JanGorman/Table): For printing tabular output on command line

### TODO
- Validation is pending for a single package weight to not exceed vehicle's max capacity
- Algorithm for shipment calculation is not validated in terms of performance
