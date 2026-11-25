import SwiftUI

enum Brand {
    static let forest = Color(red: 0.025, green: 0.225, blue: 0.15)
    static let cream = Color(red: 0.985, green: 0.96, blue: 0.925)
    static let leaf = Color(red: 0.58, green: 0.84, blue: 0.08)
    static let green = Color(red: 0.05, green: 0.66, blue: 0.08)
}
struct LeafMark: View {
    var body: some View {
        ZStack {
            LeafShape(right: false).fill(Brand.green)
            LeafShape(right: true).fill(Brand.leaf)
        }.aspectRatio(1, contentMode: .fit).accessibilityHidden(true)
    }
}
private struct LeafShape: Shape {
    let right: Bool
    func path(in rect: CGRect) -> Path {
        var p = Path()
        if right {
            p.move(to: CGPoint(x: 0.32,y: 0.86))
            p.addQuadCurve(to: CGPoint(x: 0.96,y: 0.05),control: CGPoint(x: 0.26,y: 0.08))
            p.addQuadCurve(to: CGPoint(x: 0.40,y: 0.93),control: CGPoint(x: 0.99,y: 0.93))
            p.addQuadCurve(to: CGPoint(x: 0.80,y: 0.26),control: CGPoint(x: 0.52,y: 0.55))
            p.addQuadCurve(to: CGPoint(x: 0.32,y: 0.86),control: CGPoint(x: 0.42,y: 0.55))
        } else {
            p.move(to: CGPoint(x: 0.32,y: 0.85))
            p.addQuadCurve(to: CGPoint(x: 0.10,y: 0.16),control: CGPoint(x: -0.12,y: 0.60))
            p.addQuadCurve(to: CGPoint(x: 0.48,y: 0.59),control: CGPoint(x: 0.42,y: 0.23))
        }
        p.closeSubpath()
        return p.applying(CGAffineTransform(a: rect.width, b: 0, c: 0, d: rect.height, tx: rect.minX, ty: rect.minY))
    }
}
struct BrandHeader: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) { LeafMark().frame(width: 32,height: 32); Text("ÉconoPanier").font(.headline) }.frame(maxWidth: .infinity, alignment: .center)
            Text(title).font(.largeTitle.bold()).accessibilityAddTraits(.isHeader)
            Text(subtitle).font(.subheadline)
        }.foregroundStyle(.white).padding(20).frame(maxWidth: .infinity, alignment: .leading).background(Brand.forest)
    }
}
struct PrimaryAction: View {
    let title: String
    let symbol: String
    var body: some View {
        Label(title, systemImage: symbol).font(.headline).frame(maxWidth: .infinity,minHeight: 48).foregroundStyle(.white).background(Brand.forest, in: RoundedRectangle(cornerRadius: 16))
    }
}
