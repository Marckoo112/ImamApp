import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    
    var coreColor: Color = Color.poonaAccent

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

//  monochromatic blue =
extension Color {
    // We remove the aggressive reds and use a cool, professional blue scale
    static let appBlue   = Color(red: 0.0, green: 0.478, blue: 1.0) // System blue
    static let appSky    = Color(red: 0.353, green: 0.784, blue: 0.980) // Light blue
    static let appIndigo = Color(red: 0.345, green: 0.337, blue: 0.839) // Indigo
    static let appGreen  = Color.green
    static let appOrange = Color.orange
    static let appDark   = Color.black.opacity(0.85)
    static let CardColor = Color("CardColor")

    // Semantic tokens
    static let poonaAccent = Color.appBlue
    static let poonaBackground = Color(uiColor: .systemBackground)
    static let poonaSecondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let poonaLabel = Color.primary
    static let poonaSecondaryLabel = Color.secondary
    static let poonaCTAPrimary = Color.appBlue
    static let poonaCTASecondary = Color.clear
}

// Font constants
extension Font {
    static let poonaLargeTitle = Font.largeTitle.weight(.bold)
    static let poonaTitle = Font.title2.weight(.bold)
    static let poonaBody = Font.body
    static let poonaBodySecondary = Font.subheadline
    static let poonaCaption = Font.caption
    static let poonaCTALabel = Font.headline.weight(.semibold)
}

// Spacing constants
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

// Radius
enum Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let full: CGFloat = 999
}

// MARK: - Notification Names
extension Notification.Name {
    /// Di-post oleh ResultView saat user tap "Done".
    /// homeViews mendengarkan ini untuk dismiss fullScreenCover dan kembali ke Home.
    static let sessionCompleted = Notification.Name("com.imamapp.sessionCompleted")
}
