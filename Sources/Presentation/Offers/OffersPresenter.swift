import Table

protocol OffersPresentable {
    func displayOffers()
    func addNewOffer()
    func removeOffer()
}

struct OffersPresenter: OffersPresentable {
    let offerService: OfferService
    let cli: CLIService

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
        cli.display(output: table ?? "\(offers)")
    }

    func addNewOffer() {
        let offerData = cli.getNewOfferData()
        let newOffer = offerData.toOffer()
        offerService.add(offer: newOffer)
        cli.display(output: "\nOffers updated:")
        displayOffers()
    }

    func removeOffer() {
        let offerCode = cli.getOfferCodeToRemove().uppercased()
        offerService.removeOffer(code: offerCode)
        cli.display(output: "\nOffers updated:")
        displayOffers()
    }
}

extension OfferData {
    func toOffer() -> Offer {
        Offer(
            code: offerCode,
            discountInPercentage: discount,
            criteria: Offer.Criteria(
                distance: Offer.Range(min: minDistance, max: maxDistance),
                weight: Offer.Range(
                    min: minWeight,
                    max: maxWeight
                )
            )
        )
    }
}
