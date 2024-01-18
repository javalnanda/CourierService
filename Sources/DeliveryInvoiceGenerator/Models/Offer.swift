struct Offer {
    let code: String
    let discountInPercentage: Double
    let criteria: Criteria

    struct Criteria {
        let distance: Range
        let weight: Range
    }

    struct Range {
        let min: Double
        let max: Double
    }
}
