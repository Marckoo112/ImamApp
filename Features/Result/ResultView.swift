//
//  ResultView.swift
//  ImamApp
//

import SwiftUI

struct ResultView: View {
    let viewModel: TrainingSessionViewModel
    @Environment(\.dismiss) private var dismiss

    private let strokeName: String

    init(viewModel: TrainingSessionViewModel) {
        self.viewModel = viewModel
        let type = viewModel.selectedConfig.trainingType
        self.strokeName = type == .forehand ? "Forehand" : "Backhand"
    }

    var body: some View {
        ZStack {
            // Global Ice Blue Background
            Color(uiColor: .systemBackground).ignoresSafeArea()
            Color.appBlue.opacity(0.06).ignoresSafeArea()
            
            ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Session Result")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)

                    Text("Your \(strokeName) analysis is complete.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // MARK: - Summary Banner
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.blue.opacity(0.12))
                            .frame(width: 56, height: 56)
                        Image(systemName: "figure.badminton")
                            .font(.system(size: 26))
                            .foregroundColor(.blue)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(strokeName) Training")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text("\(Int(viewModel.selectedConfig.duration / 60 > 0 ? viewModel.selectedConfig.duration / 60 : viewModel.selectedConfig.duration)) \(viewModel.selectedConfig.duration < 60 ? "seconds" : "minutes") · \(viewModel.strokeFeedback.count) analytic points")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding(18)
                .background(Color.gray.opacity(0.04))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                // MARK: - Feedback List
                if viewModel.strokeFeedback.isEmpty {
                    noDataView
                } else {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Feedback")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)

                        VStack(spacing: 12) {
                            ForEach(viewModel.strokeFeedback) { feedback in
                                FeedbackCard(feedback: feedback)
                            }
                        }
                    }
                }

                // spacing bawah
                Spacer().frame(height: 20)
            }
            }
            .padding(24)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    // Dismiss seluruh fullScreenCover, bukan hanya 1 level NavigationStack
                    NotificationCenter.default.post(name: .sessionCompleted, object: nil)
                }
                .fontWeight(.semibold)
                .foregroundColor(.appBlue)
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var noDataView: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 36))
                .foregroundColor(.appBlue)
            Text("Your pose was not detected clearly.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Text("Ensure your entire body is visible in the frame and lighting is adequate.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
//        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    // Removed tipBox as requested
}

// MARK: - Feedback Card

private struct FeedbackCard: View {
    let feedback: StrokeFeedback

    var iconColor: Color {
        return .appBlue
    }

    var backgroundColor: Color {
        return Color.appBlue.opacity(0.07)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: feedback.priority.icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 5) {
                Text(feedback.title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)

                Text(feedback.detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(iconColor.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        ResultView(viewModel: TrainingSessionViewModel())
    }
}
