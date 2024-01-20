import XCTest
@testable import CourierService
import Table

class AppRouterTests: XCTestCase {

    func test_selecting_calculateCost_displays_calculatedCost() {
        let packages = [
            PackageData(id: "PKG1", weight: 5.0, distance: 5.0, offer: "OFR001"),
            PackageData(id: "PKG2", weight: 15.0, distance: 5.0, offer: "OFR002"),
            PackageData(id: "PKG3", weight: 10.0, distance: 100.0, offer: "OFR003")
        ]
        let (sut, cli, _) = makeSut(userChoice: ServiceOption.deliveryCost, packages: packages)

        sut.showMainMenu()

        let expectedCostOfDeliveries = [
            DeliveryCost(packageId: "PKG1", discount: 0, totalCost: 175),
            DeliveryCost(packageId: "PKG2", discount: 0, totalCost: 275),
            DeliveryCost(packageId: "PKG3", discount: 35, totalCost: 665),
        ]
        let expectedDisplayedOut = generateCostExpectedOutput(costOfDeliveries: expectedCostOfDeliveries)
        XCTAssertEqual(expectedDisplayedOut, cli.displayedOutput)
    }

    func test_selecting_calculateTime_displays_calculatedCostAndTime() {
        let packages = [
            PackageData(id: "PKG1", weight: 50.0, distance: 30.0, offer: "OFR001"),
            PackageData(id: "PKG2", weight: 75.0, distance: 125.0, offer: "OFR0008"),
            PackageData(id: "PKG3", weight: 175.0, distance: 100.0, offer: "OFFR003"),
            PackageData(id: "PKG4", weight: 110.0, distance: 60.0, offer: "OFR002"),
            PackageData(id: "PKG5", weight: 155.0, distance: 95.0, offer: "")
        ]
        let (sut, cli, _) = makeSut(userChoice: ServiceOption.deliveryTime, packages: packages)

        sut.showMainMenu()

        let expectedCostAndTimeOfDeliveries = [
            DeliveryCostAndTime(packageId: "PKG1", discount: 0.0, totalCost: 750.0, estimatedDeliveryTime: "3.98"),
            DeliveryCostAndTime(packageId: "PKG2", discount: 0.0, totalCost: 1475.0, estimatedDeliveryTime: "1.78"),
            DeliveryCostAndTime(packageId: "PKG3", discount: 0.0, totalCost: 2350.0, estimatedDeliveryTime: "1.42"),
            DeliveryCostAndTime(packageId: "PKG4", discount: 105.0, totalCost: 1395.0, estimatedDeliveryTime: "0.85"),
            DeliveryCostAndTime(packageId: "PKG5", discount: 0.0, totalCost: 2125.0, estimatedDeliveryTime: "4.19"),
        ]
        let expectedDisplayedOut = generateCostAndTimeExpectedOutput(costAndTimeOfDeliveries: expectedCostAndTimeOfDeliveries)
        XCTAssertEqual(expectedDisplayedOut, cli.displayedOutput)
    }

    func test_selecting_getAllOffers_displays_allOffers() {
        let (sut, cli, _) = makeSut(userChoice: ServiceOption.getAllOffers)

        sut.showMainMenu()

        let expectedOffers = generatedExpectedOffersOutput()
        XCTAssertEqual(expectedOffers, cli.displayedOutput)
    }

    func test_selecting_addNewOffer_adds_newOffer() {
        let newOfferData = OfferData(
            offerCode: "OFR004",
            discount: 2.0,
            minWeight: 10,
            maxWeight: 100,
            minDistance: 40,
            maxDistance: 250
        )
        let (sut, cli, _) = makeSut(userChoice: ServiceOption.addNewOffer, newOfferData: newOfferData)

        sut.showMainMenu()

        let expectedOutput = generatedExpectedOffersOutput(newOffer: newOfferData.toOffer())
        XCTAssertEqual(expectedOutput, cli.displayedOutput)
    }

    func test_selecting_removeOffer_removes_offer_for_provided_offerCode() {
        let newOfferData = OfferData(
            offerCode: "OFR004",
            discount: 2.0,
            minWeight: 10,
            maxWeight: 100,
            minDistance: 40,
            maxDistance: 250
        )
        let (sut, cli, offerStore) = makeSut(userChoice: ServiceOption.removeOffer, offerToRemove: "OFR004")
        offerStore.add(offer: newOfferData.toOffer())

        sut.showMainMenu()

        let expectedOutput = generatedExpectedOffersOutput()
        XCTAssertEqual(expectedOutput, cli.displayedOutput)
    }

    private func makeSut(
        userChoice: ServiceOption,
        baseDeliveryCost: Double = 100,
        packages: [PackageData] = [],
        newOfferData: OfferData? = nil,
        offerToRemove: String? = nil
    ) -> (AppRouter, MockCLi, MockOfferStore) {
        let cli = MockCLi(
            userChoice: userChoice,
            baseDeliveryCost: baseDeliveryCost,
            packages: packages,
            newOfferData: newOfferData,
            offerToRemove: offerToRemove
        )
        let offerService = MockOfferStore()
        let courierDelivery = CourierDeliveryFactory().build(offerService: offerService)
        let courierDeliveryPresenter = CourierDeliveryPresenter(courierDelivery: courierDelivery, cli: cli)
        let offersPresenter = OffersPresenter(offerService: offerService, cli: cli)
        let router = AppRouter(courierDeliveryPresenter: courierDeliveryPresenter, offersPresenter: offersPresenter, cli: cli)
        return (router, cli, offerService)
    }

    private func generateCostExpectedOutput(costOfDeliveries: [DeliveryCost]) -> String {
        var tabularData = costOfDeliveries.map { deliveryCost in
            [
                "\(deliveryCost.packageId)",
                "\(deliveryCost.discount)",
                "\(deliveryCost.totalCost)"
            ]
        }
        let headerData = ["PackageId", "Discount", "Total Cost"]
        tabularData.insert(headerData, at: 0)
        let table = try? Table(data: tabularData).table()
        return table!
    }

    private func generateCostAndTimeExpectedOutput(costAndTimeOfDeliveries: [DeliveryCostAndTime]) -> String {
        var tabularData = costAndTimeOfDeliveries.map { costAndTime in
            [
                "\(costAndTime.packageId)",
                "\(costAndTime.discount)",
                "\(costAndTime.totalCost)",
                "\(costAndTime.estimatedDeliveryTime)"
            ]
        }
        let headerData = ["PackageId", "Discount", "Total Cost", "Estimated Delivery Time"]
        tabularData.insert(headerData, at: 0)
        let table = try? Table(data: tabularData).table()
        return table!
    }

    private func generatedExpectedOffersOutput(newOffer: Offer? = nil) -> String {
        var offers = [
            Offer(
                code: "OFR001",
                discountInPercentage: 10,
                criteria: Offer.Criteria(
                    distance: Offer.Range(min: 0, max: 199),
                    weight: Offer.Range(min: 70, max: 200)
                )
            ),
            Offer(
                code: "OFR002",
                discountInPercentage: 7,
                criteria: Offer.Criteria(
                    distance: Offer.Range(min: 50, max: 150),
                    weight: Offer.Range(min: 100, max: 250)
                )
            ),
            Offer(
                code: "OFR003",
                discountInPercentage: 5,
                criteria: Offer.Criteria(
                    distance: Offer.Range(min: 50, max: 250),
                    weight: Offer.Range(min: 10, max: 150)
                )
            ),
        ]
        if let offerToAdd = newOffer {
            offers.append(offerToAdd)
        }
        var tabularData = offers.map { offer in
            [
                "\(offer.code)",
                "\(offer.discountInPercentage)",
                "\(offer.criteria.distance.min)",
                "\(offer.criteria.distance.max)",
                "\(offer.criteria.weight.min)",
                "\(offer.criteria.weight.max)",
            ]
        }
        let headerData = [
            "Offer Code", "Discount (%)", "Min Distance", "Max Distance", "Min Weight", "Max Weight"
        ]
        tabularData.insert(headerData, at: 0)
        let table = try? Table(data: tabularData).table()
        return table!
    }
}

private class MockCLi: CLIService {
    let userChoice: ServiceOption
    let baseDeliveryCost: Double
    let packages: [PackageData]
    var vehicleData: VehicleData = VehicleData(
        numberOfVehicles: 2,
        maxSpeed: 70,
        maxWeightCapacity: 200
    )
    let newOfferData: OfferData?
    var offerToRemove: String?
    var displayedOutput: String = ""

    init(
        userChoice: ServiceOption,
        baseDeliveryCost: Double,
        packages: [PackageData],
        newOfferData: OfferData?,
        offerToRemove: String? = nil
    ) {
        self.userChoice = userChoice
        self.baseDeliveryCost = baseDeliveryCost
        self.packages = packages
        self.newOfferData = newOfferData
        self.offerToRemove = offerToRemove
    }
    func getUserChoice() -> ServiceOption {
        userChoice
    }

    func getInputsForCostCalculation() -> (baseDeliveryCost: Double, packages: [PackageData]) {
        (baseDeliveryCost, packages)
    }

    func getVehicleInfo() -> VehicleData {
        vehicleData
    }

    func getNewOfferData() -> OfferData {
        newOfferData!
    }

    func getOfferCodeToRemove() -> String {
        offerToRemove!
    }

    func display(output: String) {
        displayedOutput = output
    }
}
