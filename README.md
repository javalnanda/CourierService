# CourierService

CourierService is a command line tool written in Swift for dealing with courier services. This tool solves following problems:

## **Problem 01**

### Total delivery cost estimation
Total delivery cost for a package is calculated by applying discount if applicable based on the offer code.
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
