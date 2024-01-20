protocol OfferService {
    func getAllOffers() -> [Offer]
    func getOfferBy(code: String) -> Offer?
    func add(offer: Offer)
    func removeOffer(code: String)
}
