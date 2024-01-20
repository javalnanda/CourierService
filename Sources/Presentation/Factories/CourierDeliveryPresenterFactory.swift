struct CourierDeliveryPresenterFactory {
    func build() -> CourierDeliveryPresentable {
        let courierDelivery = CourierDeliveryFactory().build()
        let cli = CLI.shared
        return CourierDeliveryPresenter(courierDelivery: courierDelivery, cli: cli)
    }
}
