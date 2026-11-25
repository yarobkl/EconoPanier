import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ListEntry.createdAt) private var entries: [ListEntry]
    @State private var name = ""
    @State private var quantity = 1
    @State private var failure = false
    var body: some View {
        List {
            Section("Ma liste de courses") {
                TextField("Produit", text: $name)
                Stepper("Quantité : \(quantity)", value: $quantity, in: 1...999)
                Button("Ajouter") {
                    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    context.insert(ListEntry(name: trimmed, quantity: quantity))
                    if save() { name = ""; quantity = 1 }
                }.disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            Section("\(entries.filter(\.checked).count) sur \(entries.count) cochés") {
                if entries.isEmpty { Text("Votre liste est vide.").foregroundStyle(.secondary) }
                ForEach(entries) { item in
                    Button { item.checked.toggle(); _ = save() } label: { HStack { Image(systemName: item.checked ? "checkmark.circle.fill" : "circle"); Text(item.name).strikethrough(item.checked); Spacer(); Text("×\(item.quantity)") } }.buttonStyle(.plain).accessibilityLabel("\(item.name), quantité \(item.quantity), \(item.checked ? "coché" : "non coché")")
                }.onDelete { indices in for index in indices { context.delete(entries[index]) }; _ = save() }
            }
        }.navigationTitle("Courses").alert("Enregistrement impossible", isPresented: $failure) { Button("OK", role: .cancel) {} }
    }
    private func save() -> Bool { do { try context.save(); return true } catch { context.rollback(); failure = true; return false } }
}
