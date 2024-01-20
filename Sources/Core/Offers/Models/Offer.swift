struct Offer: Equatable {
    let code: String
    let discountInPercentage: Double
    let criteria: Criteria

    struct Criteria: Equatable {
        let distance: Range
        let weight: Range
    }

    struct Range: Equatable {
        let min: Double
        let max: Double
    }
}
