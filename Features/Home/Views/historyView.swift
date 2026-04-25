import SwiftUI



struct TrainingSession {
    let date: String
    let stroke: String
    let score: String
    let miss: String
    let accuracy: String
    let feedback: String
}


struct StatRowView: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(color)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
        }
    }
}



struct SessionCardView: View {
    let session: TrainingSession

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // header kartu: tanggal + stroke
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.date)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(session.stroke)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                }

                Spacer()

                Image(systemName: "figure.tennis")
                    .font(.system(size: 22))
                    .foregroundColor(.red.opacity(0.6))
            }

            Divider()

            // stats baris-baris
            VStack(spacing: 10) {
                StatRowView(label: "Score", value: session.score, icon: "star.fill", color: .orange)
                StatRowView(label: "Miss", value: session.miss, icon: "xmark.circle.fill", color: .red)
                StatRowView(label: "Accuracy", value: session.accuracy, icon: "scope", color: .green)
            }

            if !session.feedback.isEmpty {
                Divider()
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "text.bubble.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                    Text(session.feedback)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(18)
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}


struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 20)

            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 56))
                .foregroundColor(Color(uiColor: .systemGray3))

            VStack(spacing: 8) {
                Text("No Sessions Yet")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text("Your training history will appear here after you complete your first session.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity)
    }
}


struct historyView: View {

    // contoh data dummy 
    private let dummySessions: [TrainingSession] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // Title
                VStack(alignment: .leading, spacing: 4) {
                    Text("History")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Your past training sessions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // kalau belum ada data
                if dummySessions.isEmpty {
                    EmptyStateView()
                } else {
                    // nanti isi dari list session asli
                    ForEach(dummySessions, id: \.date) { session in
                        SessionCardView(session: session)
                    }
                }
            }
            .padding(24)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
        }
    }
}

#Preview {
    historyView()
}
