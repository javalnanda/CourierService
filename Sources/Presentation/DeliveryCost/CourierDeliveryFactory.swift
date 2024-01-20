struct CourierDeliveryFactory {
    func build() -> CourierDelivery {
        let costCalculator = DeliveryCostCalculator(offerService: CourierService.offerStore)
        let timeCalculator = DeliveryTimeCalculator()
        return CourierDelivery(deliveryCostCalculator: costCalculator, deliveryTimeCalculator: timeCalculator)
    }
}
