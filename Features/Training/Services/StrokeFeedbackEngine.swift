//
//  StrokeFeedbackEngine.swift
//  ImamApp
//

import Foundation

// A single piece of feedback from analysis
struct StrokeFeedback: Identifiable {
    let id = UUID()
    let priority: Priority
    let title: String
    let detail: String

    enum Priority: Int, Comparable {
        case critical = 0
        case improve = 1
        case good = 2

        static func < (lhs: Priority, rhs: Priority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        var icon: String {
            switch self {
            case .critical: return "exclamationmark.circle.fill"
            case .improve: return "arrow.up.circle.fill"
            case .good: return "checkmark.circle.fill"
            }
        }
    }
}

// This engine takes the accumulated angle data from a session,
// and returns a list of useful, concrete feedback for the user.
enum StrokeFeedbackEngine {

    // Main entry point — call this when a session ends
    static func analyze(
        angles: [String: [CGFloat]],
        strokeType: TrainingModule.TrainingType
    ) -> [StrokeFeedback] {
        guard !angles.isEmpty else { return [noDataFeedback()] }

        // Average for each angle
        let averages = angles.mapValues { values -> CGFloat in
            values.reduce(0, +) / CGFloat(values.count)
        }

        switch strokeType {
        case .forehand:
            return analyzeForehand(averages: averages)
        case .backhand:
            return analyzeBackhand(averages: averages)
        case .comingsoon:
            return []
        }
    }

    // MARK: - Forehand Analysis

    private static func analyzeForehand(averages: [String: CGFloat]) -> [StrokeFeedback] {
        var feedbacks: [StrokeFeedback] = []

        // --- Elbow angle ---
        // Ideal at impact: 100–130°. Less → too bent, more → too straight
        if let elbow = dominantElbow(from: averages) {
            if elbow < 85 {
                feedbacks.append(StrokeFeedback(
                    priority: .critical,
                    title: "Elbow Too Bent",
                    detail: "Your elbow angle averaged \(Int(elbow))°. Try straightening it more during your swing—aim for around 110–125° at impact to maximize your power."
                ))
            } else if elbow < 100 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Open Your Elbow More",
                    detail: "Your elbow angle is around \(Int(elbow))°. Straighten it slightly as you swing forward, aiming for 110°+ for a more powerful shot."
                ))
            } else if elbow > 155 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Elbow Too Straight",
                    detail: "An elbow angle of \(Int(elbow))° is too open. Bend it a little more to improve your control and reduce the risk of injury."
                ))
            } else {
                feedbacks.append(StrokeFeedback(
                    priority: .good,
                    title: "Great Elbow Angle",
                    detail: "An average of \(Int(elbow))° is solid for a forehand. Keep it up!"
                ))
            }
        }

        // --- Shoulder angle ---
        // Ideal: 70–110° when lifting the arm for a swing
        if let shoulder = dominantShoulder(from: averages) {
            if shoulder < 55 {
                feedbacks.append(StrokeFeedback(
                    priority: .critical,
                    title: "Shoulder Needs Lifting",
                    detail: "Your shoulder angle is \(Int(shoulder))°. Lift your arm higher when preparing to swing—at least 70° to optimize your reach."
                ))
            } else if shoulder > 130 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Shoulder Position Too High",
                    detail: "Your shoulder is lifted to \(Int(shoulder))°. Lower it slightly for a more natural, relaxed movement."
                ))
            } else {
                feedbacks.append(StrokeFeedback(
                    priority: .good,
                    title: "Good Shoulder Position",
                    detail: "Your shoulder angle of \(Int(shoulder))° shows consistent rotation. Keep it up!"
                ))
            }
        }

        // --- Knee bend ---
        // Knees should be slightly bent (~130–160°) for agility
        if let knee = averages["Right Knee"] ?? averages["Left Knee"] {
            if knee > 170 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Bend Your Knees More",
                    detail: "Your knees are almost straight (\(Int(knee))°). Bend them slightly in the ready position—around 140–160°—to respond to the shuttle faster."
                ))
            } else if knee < 110 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Knee Position Too Low",
                    detail: "Your knees are bent too much (\(Int(knee))°). Stand a bit more upright for more efficient movement."
                ))
            } else {
                feedbacks.append(StrokeFeedback(
                    priority: .good,
                    title: "Stable Foot Stance",
                    detail: "Knees at \(Int(knee))°—a great ready position!"
                ))
            }
        }

        return feedbacks.sorted { $0.priority < $1.priority }
    }

    // MARK: - Backhand Analysis

    private static func analyzeBackhand(averages: [String: CGFloat]) -> [StrokeFeedback] {
        var feedbacks: [StrokeFeedback] = []

        // --- Elbow angle ---
        // Backhand needs a more bent elbow during preparation: ~80–110°
        if let elbow = dominantElbow(from: averages) {
            if elbow > 145 {
                feedbacks.append(StrokeFeedback(
                    priority: .critical,
                    title: "Bend Elbow More for Backhand",
                    detail: "An elbow angle of \(Int(elbow))° is too straight. For a backhand, bend your elbow to around 90–110° during prep for better power transfer."
                ))
            } else if elbow < 65 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Elbow Too Bent",
                    detail: "Your elbow angle is only \(Int(elbow))°. Try to open it slightly to give yourself enough swing room—aim for around 85–100°."
                ))
            } else {
                feedbacks.append(StrokeFeedback(
                    priority: .good,
                    title: "Perfect Elbow Bend",
                    detail: "An average of \(Int(elbow))° is ideal for a backhand. Maintain this consistency!"
                ))
            }
        }

        // --- Shoulder angle ---
        // Backhand: shoulders actively rotate — shoulder angle ~60–100°
        if let shoulder = dominantShoulder(from: averages) {
            if shoulder < 45 {
                feedbacks.append(StrokeFeedback(
                    priority: .critical,
                    title: "Increase Shoulder Rotation",
                    detail: "A shoulder angle of \(Int(shoulder))° is too small. Rotate your shoulders more actively to generate power from your body, not just your arm."
                ))
            } else if shoulder > 120 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Shoulder Too Open",
                    detail: "Your shoulder is at \(Int(shoulder))°—too wide. Control the rotation so you don't lose the direction of the shuttle."
                ))
            } else {
                feedbacks.append(StrokeFeedback(
                    priority: .good,
                    title: "Great Shoulder Rotation",
                    detail: "A shoulder angle of \(Int(shoulder))° shows active body rotation, which is key to a strong backhand!"
                ))
            }
        }

        // --- Knee bend ---
        if let knee = averages["Left Knee"] ?? averages["Right Knee"] {
            if knee > 170 {
                feedbacks.append(StrokeFeedback(
                    priority: .improve,
                    title: "Knees Need More Flexibility",
                    detail: "At \(Int(knee))°, your knees are almost straight. Bend them slightly so you can rotate your body more freely during the backhand."
                ))
            } else {
                feedbacks.append(StrokeFeedback(
                    priority: .good,
                    title: "Solid Foot Position",
                    detail: "Knees at \(Int(knee))°—your stance supports your backhand motion well!"
                ))
            }
        }

        return feedbacks.sorted { $0.priority < $1.priority }
    }

    // MARK: - Helpers

    private static func dominantElbow(from averages: [String: CGFloat]) -> CGFloat? {
        // Take the elbow with the most data, fallback to the other
        averages["Right Elbow"] ?? averages["Left Elbow"]
    }

    private static func dominantShoulder(from averages: [String: CGFloat]) -> CGFloat? {
        averages["Right Shoulder"] ?? averages["Left Shoulder"]
    }

    private static func noDataFeedback() -> StrokeFeedback {
        StrokeFeedback(
            priority: .improve,
            title: "Insufficient Data",
            detail: "Your body position wasn't detected well during the session. Make sure your full body is visible in the camera and the lighting is bright enough."
        )
    }
}
