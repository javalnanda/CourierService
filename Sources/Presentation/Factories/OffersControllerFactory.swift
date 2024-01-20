struct OffersControllerFactory {
    func build() -> OffersController {
        OffersController(offerService: OfferStore.shared)
    }
}
