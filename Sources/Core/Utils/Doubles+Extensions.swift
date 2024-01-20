import Foundation

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }

    func toString(decimalPlaces: Int = 2) -> String {
        let truncatedDouble = self.truncate(places: decimalPlaces)
        return String(format: "%.\(decimalPlaces)f", truncatedDouble)
    }
}
