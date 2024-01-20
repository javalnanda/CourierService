struct OffersPresenterFactory {
    func build() -> OffersPresenter {
        OffersPresenter(offerService: OfferStore.shared)
    }
}
