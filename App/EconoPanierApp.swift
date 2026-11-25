import SwiftUI
import SwiftData

@main struct EconoPanierApp: App {
    private let result: Result<ModelContainer, Error> = Result {
        let schema = Schema([ListEntry.self, StockLot.self, MonthlyBudget.self, StockEvent.self])
        let config = ModelConfiguration("EconoPanierLocal", schema: schema, cloudKitDatabase: .none)
        return try ModelContainer(for: schema, configurations: [config])
    }
    var body: some Scene {
        WindowGroup {
            switch result {
            case .success(let container): RootView().modelContainer(container).preferredColorScheme(.light)
            case .failure:
                ContentUnavailableView("Données indisponibles", systemImage: "exclamationmark.triangle", description: Text("Fermez puis rouvrez l’application. Vos données n’ont pas été effacées."))
            }
        }
    }
}
