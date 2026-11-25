import SwiftUI
import CoreHaptics

private enum Tab: Hashable { case home, courses, stock, analysis, more }
struct RootView: View {
    @State private var selection: Tab = .home
    @State private var showingIntro = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { HomeView(openCourses: { selection = .courses }, openStock: { selection = .stock }, openAnalysis: { selection = .analysis }) }.tabItem { Label("Accueil", systemImage: "house") }.tag(Tab.home)
            NavigationStack { ShoppingListView() }.tabItem { Label("Courses", systemImage: "cart") }.tag(Tab.courses)
            NavigationStack { StockView() }.tabItem { Label("Stock", systemImage: "refrigerator") }.tag(Tab.stock)
            NavigationStack { BudgetView() }.tabItem { Label("Analyse", systemImage: "chart.bar") }.tag(Tab.analysis)
            NavigationStack { PreferencesView() }.tabItem { Label("Plus", systemImage: "square.grid.2x2") }.tag(Tab.more)
        }.tint(Brand.forest).overlay {
            if showingIntro && !reduceMotion {
                IntroView { withAnimation(.easeInOut(duration: 0.25)) { showingIntro = false } }.transition(.opacity)
            }
        }.onChange(of: reduceMotion) { _, value in if value { showingIntro = false } }
    }
}
private struct IntroView: View {
    let finish: () -> Void
    @AppStorage("hapticsEnabled") private var haptics = true
    @State private var phase = 0
    @State private var engine: CHHapticEngine?
    var body: some View {
        ZStack {
            Brand.forest.ignoresSafeArea()
            VStack(spacing: 12) {
                ZStack {
                    Capsule().fill(Color(red: 0.85,green: 0.72,blue: 0.47)).frame(width: 13,height: 19).rotationEffect(.degrees(-24)).opacity(phase == 0 ? 1 : 0)
                    Capsule().fill(Brand.green).frame(width: 4,height: 42).offset(y: 25).scaleEffect(y: phase >= 1 && phase < 3 ? 1 : 0,anchor: .bottom)
                    LeafMark().frame(width: 108,height: 108).scaleEffect(phase == 0 ? 0.001 : phase == 1 ? 0.28 : 1,anchor: .bottom).opacity(phase == 0 ? 0 : 1)
                }.frame(height: 125)
                Text("ÉconoPanier").font(.largeTitle.bold()).foregroundStyle(.white).scaleEffect(phase < 2 ? 0.72 : 1).opacity(phase < 2 ? 0 : 1)
                Text("Mieux acheter. Moins gaspiller.").foregroundStyle(.white.opacity(0.9)).font(.subheadline).opacity(phase >= 3 ? 1 : 0)
            }.accessibilityHidden(true)
            VStack { Spacer(); Button("Passer", action: finish).foregroundStyle(.white).padding(24) }
        }.task {
            if haptics && CHHapticEngine.capabilitiesForHardware().supportsHaptics {
                do { engine = try CHHapticEngine(); try engine?.start() } catch { engine = nil }
            }
            defer { engine?.stop(completionHandler: nil) }
            do {
                try await Task.sleep(for: .milliseconds(400)); pulse(0.23)
                withAnimation(.easeInOut(duration: 0.65)) { phase = 1 }
                try await Task.sleep(for: .milliseconds(650)); pulse(0.43)
                withAnimation(.easeInOut(duration: 0.8)) { phase = 2 }
                try await Task.sleep(for: .milliseconds(800)); withAnimation(.easeInOut(duration: 0.35)) { phase = 3 }
                try await Task.sleep(for: .milliseconds(850)); finish()
            } catch { /* Annulation lors du saut ou de la disparition. */ }
        }
    }
    private func pulse(_ intensity: Float) {
        guard haptics, let engine else { return }
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [.init(parameterID: .hapticIntensity,value: intensity), .init(parameterID: .hapticSharpness,value: 0.25)], relativeTime: 0)
        do { let player = try engine.makePlayer(with: CHHapticPattern(events: [event], parameters: [])); try player.start(atTime: CHHapticTimeImmediate) } catch { /* Haptique facultative. */ }
    }
}
