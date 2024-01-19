struct DeliveryInvoiceGeneratorFactory {
    func build() -> DeliveryInvoiceGenerator {
        let costCalculator = DeliveryCostCalculator(offerService: CourierService.offerStore)
        return DeliveryInvoiceGenerator(deliveryCostCalculator: costCalculator)
    }
}
