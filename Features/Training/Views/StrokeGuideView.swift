//
//  StrokeGuideView.swift
//  ImamApp
//
//  Layar instruksi visual yang muncul tepat sebelum kamera menyala,
//  menjelaskan perbedaan gerakan Forehand dan Backhand kepada pengguna.
//

import SwiftUI

struct StrokeGuideView: View {
    let strokeType: TrainingModule.TrainingType
    @Bindable var viewModel: TrainingSessionViewModel

    @State private var showCamera = false
    @State private var showContent = false
    @State private var selectedStep = 0

    private var strokeName: String {
        strokeType == .forehand ? "Forehand" : "Backhand"
    }

    private var accentColor: Color {
        strokeType == .forehand ? .appBlue : .appBlue
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            Color.appBlue.opacity(0.06).ignoresSafeArea()

            VStack(spacing: 20) {

                VStack(spacing: 8) {
                    Text("How To")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(accentColor)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(accentColor.opacity(0.12))
                        .clipShape(Capsule())

                    Text("\(strokeName) Technique")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)

                }
                .padding(.top, 40)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
//                .animation(.spring(duration: 0.6), value: showContent)

//                Spacer()

                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.06))
                        .frame(width: 230, height: 230)
                    Circle()
                        .stroke(accentColor.opacity(0.15), lineWidth: 2)
                        .frame(width: 210, height: 210)
                    StrokeIllustration(isBackhand: strokeType == .backhand, accentColor: accentColor)
                }
//                .opacity(showContent ? 1 : 0)
//                .scaleEffect(showContent ? 1 : 0.85)
//                .animation(.spring(duration: 0.7).delay(0.1), value: showContent)

                Spacer()

                // MARK: - Step Cards
                VStack(spacing: 10) {
                    ForEach(steps.indices, id: \.self) { i in
                        StepCard(
                            step: steps[i],
                            number: i + 1,
                            accentColor: accentColor,
                            isActive: selectedStep == i
                        )
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.3)) { selectedStep = i }
                        }
//                        .opacity(showContent ? 1 : 0)
//                        .offset(y: showContent ? 0 : 30)
//                        .animation(.spring(duration: 0.5).delay(0.15 + Double(i) * 0.1), value: showContent)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                Button {
                    showCamera = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                        Text("I'm Ready, Open Camera")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
//                .opacity(showContent ? 1 : 0)
//                .offset(y: showContent ? 0 : 20)
//                .animation(.spring(duration: 0.6).delay(0.4), value: showContent)
            }
        }
        .navigationTitle("\(strokeName) Guide")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showCamera) {
            CameraSessionView(viewModel: viewModel)
        }
        .onAppear {
            showContent = true
        }
    }


    private var steps: [(icon: String, title: String, description: String)] {
        if strokeType == .forehand {
            return [
                ("figure.stand", "Stance", "Position your feet shoulder-width apart, leaning your body slightly forward."),
                ("arrow.left.and.right.circle", "Backswing", "Pull the racket back to your dominant side at shoulder height."),
                ("arrow.forward.circle.fill", "Swing & Follow", "Swing the racket from the side to the front, finishing above the opposite shoulder."),
            ]
        } else {
            return [
                ("figure.stand", "Stance", "Point your non-dominant side forward, keeping your weight on the back foot."),
                ("arrow.left.circle", "Cross Backswing", "Cross the racket across your chest toward your non-dominant side."),
                ("arrow.forward.circle.fill", "Swing & Follow", "Swing the racket outward and forward, finishing in front of your body."),            ]
        }
    }
}



private struct StrokeIllustration: View {
    let isBackhand: Bool
    let accentColor: Color
    @State private var swingProgress: CGFloat = 0

    var body: some View {
        ZStack {
            Image(systemName: "figure.badminton")
                .font(.system(size: 90))
                .foregroundStyle(accentColor)
                .scaleEffect(x: isBackhand ? -1 : 1, y: 1)

            SwingArcShape(progress: swingProgress, isBackhand: isBackhand)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 4]))
                .foregroundStyle(accentColor.opacity(0.65))
                .frame(width: 120, height: 90)
                .offset(x: isBackhand ? -10 : 10, y: -10)
        }
//        .onAppear {
//            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
//                swingProgress = 1
//            }
//        }
    }
}

private struct SwingArcShape: Shape {
    var progress: CGFloat
    let isBackhand: Bool

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = min(rect.width, rect.height) * 0.85
        let startAngle: Angle = isBackhand ? .degrees(210) : .degrees(330)
        let sweep = 130.0 * progress
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: .degrees(startAngle.degrees + (isBackhand ? sweep : -sweep)),
            clockwise: !isBackhand
        )
        return path
    }
}



private struct StepCard: View {
    let step: (icon: String, title: String, description: String)
    let number: Int
    let accentColor: Color
    let isActive: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(isActive ? accentColor : accentColor.opacity(0.1))
                    .frame(width: 40, height: 40)
                Text("\(number)")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(isActive ? .white : accentColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(step.title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                Text(step.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
//                .shadow(color: accentColor.opacity(isActive ? 0.14 : 0.05), radius: isActive ? 8 : 4, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(isActive ? accentColor.opacity(0.4) : Color.clear, lineWidth: 1.5)
        )
    }
}

#Preview {
    NavigationStack {
        StrokeGuideView(strokeType: .forehand, viewModel: TrainingSessionViewModel())
    }
}
