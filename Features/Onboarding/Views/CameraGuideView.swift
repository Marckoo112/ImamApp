//
//  CameraGuideView.swift
//  ImamApp
//

import SwiftUI

// Data for a camera guide step
struct CameraGuideStep: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

// A concise guide on how to set up the camera for badminton training
struct CameraGuideView: View {
    @Environment(\.dismiss) private var dismiss

    // Condensed into 3 snappy, actionable steps
    private let steps: [CameraGuideStep] = [
        CameraGuideStep(
            icon: "iphone",
            title: "Position Device",
            description: "Place your phone upright, about 2-3 meters away, roughly at chest height."
        ),
        CameraGuideStep(
            icon: "person.crop.rectangle",
            title: "Check Framing",
            description: "Ensure your entire body, from head to toe, is clearly visible on the screen."
        ),
        CameraGuideStep(
            icon: "sun.max",
            title: "Good Lighting",
            description: "Face the light source. Avoid having bright light directly behind you."
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Global Ice Blue Background
                Color(uiColor: .systemBackground).ignoresSafeArea()
                Color.appBlue.opacity(0.06).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                    // HEADER
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Camera Setup")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)

                        Text("Follow these quick steps so the AI can accurately track your movements.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // STEP LIST
                    VStack(spacing: 0) {
                        ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                            StepRow(step: step, number: index + 1, isLast: index == steps.count - 1)
                        }
                    }
                    .background(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .appBlue.opacity(0.04), radius: 6, x: 0, y: 3)

                    // QUICK TIP BANNER
                    HStack(spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.appSky)
                            .font(.system(size: 20))
                        
                        Text("Wear clothing that contrasts with your background for the best tracking results.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.appSky.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.appSky.opacity(0.3), lineWidth: 1)
                    )

                    Spacer().frame(height: 8)
                }
                .padding(24)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.body.weight(.semibold))
                    .foregroundColor(.appBlue)
                }
            }
            }
        }
    }
}

// MARK: - Step Row

private struct StepRow: View {
    let step: CameraGuideStep
    let number: Int
    let isLast: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                // Number + Icon in a sleek rounded container
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.appBlue.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: step.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.appBlue)
                }

                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)

                    Text(step.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)

            if !isLast {
                Divider()
                    .padding(.leading, 76) // align divider with text
            }
        }
    }
}

#Preview {
    CameraGuideView()
}
