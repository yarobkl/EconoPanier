import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var context
    @Query private var budgets: [MonthlyBudget]
    @State private var amount = ""
    @State private var failure = false
    private var current: MonthlyBudget? { budgets.first { $0.monthKey == MonthlyBudget.key() } }
    var body: some View {
        Form {
            Section("Mon budget mensuel") {
                if let current { Text(Money.format(current.limitCents)).font(.largeTitle.bold()) } else { Text("Aucun budget défini.") }
                TextField("Montant en euros",text: $amount).keyboardType(.decimalPad)
                Button("Enregistrer") {
                    guard let value = Money.parse(amount) else { failure = true; return }
                    if let current { current.limitCents = value } else { context.insert(MonthlyBudget(monthKey: MonthlyBudget.key(),limitCents: value)) }
                    do { try context.save(); amount = "" } catch { context.rollback(); failure = true }
                }.disabled(Money.parse(amount) == nil)
            }
            Section("Dépenses et analyses") { Text("Aucun ticket confirmé. Le suivi des dépenses sera activé avec le module de rapprochement des achats.").foregroundStyle(.secondary) }
        }.navigationTitle("Analyse").alert("Montant ou enregistrement invalide",isPresented: $failure) { Button("OK",role: .cancel) {} }
    }
}
struct PreferencesView: View {
    @AppStorage("hapticsEnabled") private var haptics = true
    var body: some View {
        Form {
            Section("Mon application") { Toggle("Retours haptiques",isOn: $haptics); Text("Données enregistrées sur cet appareil. Synchronisation CloudKit non activée dans ce lot.").font(.footnote).foregroundStyle(.secondary) }
            Section("À propos") { Text("ÉconoPanier"); Text("Fondations — version de développement 0.1.0").foregroundStyle(.secondary) }
        }.navigationTitle("Plus")
    }
}
