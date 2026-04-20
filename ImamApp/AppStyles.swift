import SwiftUI


struct GradientButtonStyle: ButtonStyle {
    var coreColor: Color = Color.red

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(coreColor)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: coreColor.opacity(0.3), radius: 5, x: 0, y: 4)

    }
}

// warna utama app, diganti ke yang berani / tegas
extension Color {
    static let appBlue   = Color.blue // tetep ada blue kalau butuh
    static let appPink   = Color.red // pinknya diganti merah nyala
    static let appOrange = Color.orange // orange tegas
    static let appGreen  = Color.green
    static let appDark   = Color.black.opacity(0.85) // buat aksen gelap
    static let CardColor = Color("CardColor")
}
