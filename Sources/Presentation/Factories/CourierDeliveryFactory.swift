struct CourierDeliveryFactory {
    func build() -> CourierDelivery {
        let costCalculator = DeliveryCostCalculator(offerService: OfferStore.shared)
        let timeCalculator = DeliveryTimeCalculator()
        return CourierDelivery(deliveryCostCalculator: costCalculator, deliveryTimeCalculator: timeCalculator)
    }
}
