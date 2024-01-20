struct AppRouterFactory {
    func build() -> AppRouter {
        let courierDeliveryPresenter = CourierDeliveryPresenterFactory().build()
        let offersPresenter = OffersPresenterFactory().build()
        let cli = CLI.shared
        return AppRouter(courierDeliveryPresenter: courierDeliveryPresenter, offersPresenter: offersPresenter, cli: cli)
    }
}
