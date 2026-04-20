import SwiftUI

struct history: View {
    var body: some View {
        Text("Hello")
    }
}

struct historyView: View {

    private func historyRow(title: String, icon: String, value: String)
        -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer()

            Text(value)
                .font(.headline)
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // TITLE
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Exercise 1")
                        .font(.headline)

                    historyRow(
                        title: "Score",
                        icon: "figure.badminton",
                        value: "--"
                    )
                    historyRow(
                        title: "Miss",
                        icon: "figure.badminton",
                        value: "--"
                    )
                    historyRow(
                        title: "Accuracy",
                        icon: "figure.badminton",
                        value: "--"
                    )
                    historyRow(
                        title: "Feedback",
                        icon: "figure.badminton",
                        value: "--"
                    )

                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.CardColor)
                .cornerRadius(20)
            }
            .padding(32)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Button {

            } label: {
                Text("Reset History")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(30)
            .padding()
        }

    }
}

#Preview {
    historyView()
}
