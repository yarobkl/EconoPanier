import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var lots: [StockLot]
    @Query private var budgets: [MonthlyBudget]
    let openCourses: () -> Void
    let openStock: () -> Void
    let openAnalysis: () -> Void
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                BrandHeader(title: lots.isEmpty ? "Bienvenue !" : "Bonjour", subtitle: "Mieux acheter. Moins gaspiller.")
                VStack(spacing: 16) {
                    Button(action: openAnalysis) { HStack { VStack(alignment: .leading) { Text("Mon budget").font(.headline); Text(budgets.first(where: { $0.monthKey == MonthlyBudget.key() }).map { Money.format($0.limitCents) } ?? "Aucun budget défini.") }; Spacer(); Image(systemName: "chevron.right") }.padding(16).background(.white, in: RoundedRectangle(cornerRadius: 16)) }.buttonStyle(.plain)
                    Button(action: openStock) { PrimaryAction(title: "Ajouter un produit", symbol: "plus.viewfinder") }.buttonStyle(.plain)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mon stock").font(.title2.bold())
                        if lots.filter({ $0.quantity > 0 }).isEmpty { ContentUnavailableView("Aucun produit pour le moment", systemImage: "basket", description: Text("Ajoutez vos produits pour suivre vos réserves.")) }
                        else { Text("\(lots.filter { $0.quantity > 0 }.count) lots enregistrés"); Button("Voir mon stock", action: openStock) }
                    }.padding(16).frame(maxWidth: .infinity, alignment: .leading).background(.white,in: RoundedRectangle(cornerRadius: 18))
                    Button(action: openCourses) { PrimaryAction(title: "Ma liste de courses", symbol: "cart") }.buttonStyle(.plain)
                }.padding(.horizontal, 20)
            }.padding(.bottom,20)
        }.background(Brand.cream).navigationBarHidden(true)
    }
}
