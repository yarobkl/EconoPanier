import Foundation

enum Money {
    static func cents(_ value: Decimal) -> Int64? {
        guard !value.isNaN, value >= 0, value <= Decimal(1_000_000_000) else { return nil }
        var scaled = value * 100
        var rounded = Decimal()
        NSDecimalRound(&rounded, &scaled, 0, .plain)
        return NSDecimalNumber(decimal: rounded).int64Value
    }
    static func decimal(_ cents: Int64) -> Decimal { Decimal(cents) / 100 }
    static func parse(_ text: String) -> Int64? {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard cleaned.range(of: #"^[0-9]+(\.[0-9]{1,2})?$"#, options: .regularExpression) != nil,
              let amount = Decimal(string: cleaned, locale: Locale(identifier: "en_US_POSIX")) else { return nil }
        return cents(amount)
    }
    static func format(_ cents: Int64) -> String {
        decimal(cents).formatted(.currency(code: "EUR").locale(Locale(identifier: "fr_FR")))
    }
    static func basket(_ lines: [PricedLine]) -> BasketTotal {
        var total: Int64 = 0
        var missing = 0
        for line in lines {
            guard let price = line.unitCents, price >= 0, line.quantity > 0,
                  let amount = cents(decimal(price) * line.quantity) else { missing += 1; continue }
            let (sum, overflow) = total.addingReportingOverflow(amount)
            if overflow { missing += 1 } else { total = sum }
        }
        return BasketTotal(knownCents: total, unresolvedLines: missing)
    }
    static func priceDifference(paid: Int64, expected: Int64) -> Int64? {
        guard paid >= 0, expected >= 0 else { return nil }
        return paid - expected
    }
}
struct PricedLine { let quantity: Decimal; let unitCents: Int64? }
struct BasketTotal: Equatable { let knownCents: Int64; let unresolvedLines: Int; var isPartial: Bool { unresolvedLines > 0 } }
