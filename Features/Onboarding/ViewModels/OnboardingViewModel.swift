import SwiftUI
import Combine

// Data Model untuk pilihan tangan
struct HandOption: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let subtitle: String
    let sysImage: String
    let rotationDegrees: Double
}

// Data Model untuk pilihan pukulan/stroke
struct StrokeOption: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let subtitle: String
    let sysImage: String
    let flipHorizontal: Bool
}

// ViewModel untuk menangani logika onboarding (Tangan dan Stroke)
class OnboardingViewModel: ObservableObject {
    
    // Data Hand Options
    let handOptions: [HandOption] = [
        HandOption(title: "Left Hand",
                   value: "Left Hand",
                   subtitle: "Mirror tracking calibrated for southpaws",
                   sysImage: "hand.raised.fill",
                   rotationDegrees: 270),
        HandOption(title: "Right Hand",
                   value: "Right Hand",
                   subtitle: "Tracking for the dominant right side",
                   sysImage: "hand.raised.fill",
                   rotationDegrees: 90)
    ]
    
    // Data Stroke Options
    let strokeOptions: [StrokeOption] = [
        StrokeOption(title: "Back Hand",
                     value: "Back Hand",
                     subtitle: "Focus on control and cross-court balance",
                     sysImage: "figure.badminton.circle.fill",
                     flipHorizontal: false),
        StrokeOption(title: "Fore Hand",
                     value: "Fore Hand",
                     subtitle: "Standard tracking for the dominant right side",
                     sysImage: "figure.badminton.circle.fill",
                     flipHorizontal: true)
    ]
}
