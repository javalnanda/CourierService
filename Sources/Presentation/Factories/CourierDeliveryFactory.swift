struct CourierDeliveryFactory {
    func build(offerService: OfferService = OfferStore.shared) -> CourierDelivery {
        let costCalculator = DeliveryCostCalculator(offerService: offerService)
        let timeCalculator = DeliveryTimeCalculator()
        return CourierDelivery(deliveryCostCalculator: costCalculator, deliveryTimeCalculator: timeCalculator)
    }
}
