struct DeliveryInvoiceGeneratorFactory {
    func build() -> DeliveryInvoiceGenerator {
        let costCalculator = DeliveryCostCalculator(offerService: OfferStore())
        return DeliveryInvoiceGenerator(deliveryCostCalculator: costCalculator)
    }
}
