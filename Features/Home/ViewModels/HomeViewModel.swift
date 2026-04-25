import SwiftUI
import Combine

struct HomeStatCard: Identifiable {
    let id = UUID()
    let icon: String
    let value: String
    let label: String
}

// Summary of the last session to be displayed in the Overview
struct LastSessionSummary {
    let strokeName: String
    let date: Date
    let feedbackItems: [String]

    // Formatted relative date: "Today", "Yesterday", or formatted date
    var dateLabel: String {
        let cal = Calendar.current
        if cal.isDateInToday(date) {
            return "Today"
        } else if cal.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let f = DateFormatter()
            f.dateStyle = .medium
            f.locale = Locale(identifier: "en_US")
            return f.string(from: date)
        }
    }
}

class HomeViewModel: ObservableObject {

    @Published var stats: [HomeStatCard] = []
    @Published var lastSession: LastSessionSummary? = nil

    init() {
        loadLastSession()
        updateStats()
    }

    // Load last session data from UserDefaults
    func loadLastSession() {
        guard
            let strokeName = UserDefaults.standard.string(forKey: "lastStrokeName"),
            let date = UserDefaults.standard.object(forKey: "lastSessionDate") as? Date,
            let data = UserDefaults.standard.data(forKey: "lastFeedbackItems"),
            let items = try? JSONDecoder().decode([String].self, from: data)
        else {
            lastSession = nil
            return
        }

        lastSession = LastSessionSummary(
            strokeName: strokeName,
            date: date,
            feedbackItems: items
        )
    }

    private func updateStats() {
        // Values will be populated from history manager later
        stats = [
            HomeStatCard(icon: "figure.badminton", value: "0", label: "Sessions"),
        ]
    }
}
