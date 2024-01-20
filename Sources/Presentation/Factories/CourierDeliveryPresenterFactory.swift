struct CourierDeliveryPresenterFactory {
    func build() -> CourierDeliveryPresenter {
        return CourierDeliveryPresenter(courierDelivery: CourierDeliveryFactory().build())
    }
}
