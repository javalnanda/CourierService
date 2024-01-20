struct OffersPresenterFactory {
    func build() -> OffersPresentable {
        OffersPresenter(offerService: OfferStore.shared, cli: CLI.shared)
    }
}
