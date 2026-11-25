import SwiftUI
import SwiftData

struct StockView: View {
    @Query private var lots: [StockLot]
    @State private var add = false
    var body: some View {
        List {
            Section("Mes espaces") {
                ForEach(StorageZone.allCases) { zone in
                    NavigationLink { ZoneView(zone: zone) } label: { HStack { Label(zone.title, systemImage: zone.symbol); Spacer(); Text("\(lots.filter { $0.zoneRaw == zone.rawValue && $0.quantity > 0 }.count)").foregroundStyle(.secondary) } }
                }
            }
            Button("Ajouter un produit manuellement", systemImage: "plus") { add = true }
        }.navigationTitle("Stock").sheet(isPresented: $add) { AddLotView() }
    }
}
private struct ZoneView: View {
    let zone: StorageZone
    @Query private var lots: [StockLot]
    @Environment(\.modelContext) private var context
    @State private var selection: StockLot?
    @State private var failure = false
    var body: some View {
        List {
            let active = lots.filter { $0.zoneRaw == zone.rawValue && $0.quantity > 0 }
            if active.isEmpty { ContentUnavailableView("Aucun produit",systemImage: zone.symbol) }
            ForEach(active) { lot in
                Button { selection = lot } label: { VStack(alignment: .leading) { Text(lot.name).font(.headline); Text("\(lot.quantity) unité(s) · Date à renseigner").font(.subheadline).foregroundStyle(.secondary) } }.buttonStyle(.plain)
            }
        }.navigationTitle(zone.title).sheet(item: $selection) { lot in
            LotMovementView(lot: lot)
        }
    }
}
private struct AddLotView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var name = ""
    @State private var quantity = 1
    @State private var zone: StorageZone = .fridge
    @State private var failure = false
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nom du produit", text: $name)
                Stepper("Unités : \(quantity)", value: $quantity, in: 1...999)
                Picker("Rangement", selection: $zone) { ForEach(StorageZone.allCases) { Text($0.title).tag($0) } }
                Text("Ajout à vos réserves existantes, sans prix ni date inventés. N'enregistre aucune dépense.").font(.footnote).foregroundStyle(.secondary)
            }.navigationTitle("Ajouter au stock").toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Annuler") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Ajouter") { context.insert(StockLot(name: name.trimmingCharacters(in: .whitespacesAndNewlines),quantity: quantity,zone: zone)); do { try context.save(); dismiss() } catch { context.rollback(); failure = true } }.disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) }
            }.alert("Enregistrement impossible",isPresented: $failure) { Button("OK",role: .cancel) {} }
        }
    }
}
private struct LotMovementView: View {
    let lot: StockLot
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var kind = "consumed"
    @State private var failure = false
    var body: some View {
        NavigationStack {
            Form {
                Text(lot.name).font(.headline)
                Picker("Action", selection: $kind) { Text("Consommé").tag("consumed"); Text("Jeté").tag("wasted") }
                Stepper("Unités : \(quantity)", value: $quantity, in: 1...max(1,lot.quantity))
                Button("Confirmer") {
                    guard quantity > 0, quantity <= lot.quantity else { failure = true; return }
                    context.insert(StockEvent(lot: lot, quantity: quantity,kind: kind)); lot.quantity -= quantity
                    do { try context.save(); dismiss() } catch { context.rollback(); failure = true }
                }.disabled(lot.quantity <= 0)
            }.navigationTitle("Mettre à jour").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Annuler") { dismiss() } } }.alert("Mouvement impossible",isPresented: $failure) { Button("OK",role: .cancel) {} }
        }
    }
}
