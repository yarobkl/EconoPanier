import Foundation
import SwiftData

enum StorageZone: String, CaseIterable, Identifiable {
    case fridge, freezer, pantry, fruit
    var id: String { rawValue }
    var title: String {
        switch self { case .fridge: "Réfrigérateur"; case .freezer: "Congélateur"; case .pantry: "Placard"; case .fruit: "Corbeille à fruits" }
    }
    var symbol: String {
        switch self { case .fridge: "refrigerator"; case .freezer: "snowflake"; case .pantry: "cabinet"; case .fruit: "basket" }
    }
}
@Model final class ListEntry {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantity: Int
    var checked: Bool
    var createdAt: Date
    init(name: String, quantity: Int = 1) { id = UUID(); self.name = name; self.quantity = quantity; checked = false; createdAt = .now }
}
@Model final class StockLot {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantity: Int
    var zoneRaw: String
    var addedAt: Date
    var purchaseDate: Date?
    var dateKind: String
    var labelDate: Date?
    init(name: String, quantity: Int, zone: StorageZone) {
        id = UUID(); self.name = name; self.quantity = quantity; zoneRaw = zone.rawValue; addedAt = .now
        purchaseDate = nil; dateKind = "unknown"; labelDate = nil
    }
}
@Model final class MonthlyBudget {
    @Attribute(.unique) var monthKey: String
    var limitCents: Int64
    init(monthKey: String, limitCents: Int64) { self.monthKey = monthKey; self.limitCents = limitCents }
    static func key(for date: Date = .now) -> String {
        let c = Calendar.current.dateComponents([.year, .month], from: date)
        return String(format: "%04d-%02d", c.year ?? 0, c.month ?? 0)
    }
}
@Model final class StockEvent {
    @Attribute(.unique) var id: UUID
    var lotID: UUID
    var productName: String
    var quantity: Int
    var kind: String
    var date: Date
    init(lot: StockLot, quantity: Int, kind: String) {
        id = UUID(); lotID = lot.id; productName = lot.name; self.quantity = quantity; self.kind = kind; date = .now
    }
}
