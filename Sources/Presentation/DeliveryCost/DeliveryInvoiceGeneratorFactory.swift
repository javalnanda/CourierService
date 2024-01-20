struct DeliveryInvoiceGeneratorFactory {
    func build() -> CourierDelivery {
        let costCalculator = DeliveryCostCalculator(offerService: CourierService.offerStore)
        return CourierDelivery(deliveryCostCalculator: costCalculator)
    }
}
