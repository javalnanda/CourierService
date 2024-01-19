import SwiftCLI
import Table

struct OffersController {
    private let offerService: OfferService = CourierService.offerStore

    func displayOffers() {
        let offers = offerService.getAllOffers()

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
        print(table ?? offers)
    }

    func addNewOffer() {
        print("\nPlease enter the details of new offer:")
        let offerCode = Input.readLine(prompt: "Enter Offer Code:").uppercased()
        let discount = Input.readDouble(prompt: "Enter discount in percentage:")
        let minDistance = Input.readDouble(prompt: "Enter minimum distance to deliver for the offer to be valid:")
        let maxDistance = Input.readDouble(prompt: "Enter maximum distance to deliver for the offer to be valid:")
        let minWeight = Input.readDouble(prompt: "Enter minimum weight of the package for the offer to be valid:")
        let maxWeight = Input.readDouble(prompt: "Enter maximum weight of the package for the offer to be valid:")

        let newOffer = Offer(
            code: offerCode,
            discountInPercentage: discount,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: minDistance, max: maxDistance),
                weight: Offer.Range(min: minWeight, max: maxWeight)
            )
        )
        offerService.add(offer: newOffer)
        print("\nOffers updated:")
        displayOffers()
    }

    func removeOffer() {
        let offerCode = Input.readLine(prompt: "Please enter offer code of Offer to be removed:").uppercased()
        offerService.removeOffer(code: offerCode)
        print("\nOffers updated:")
        displayOffers()
    }
}
