//
//  JointAngleCalculator.swift
//  PoonaApp
//

import CoreGraphics
import Foundation

enum JointAngleCalculator {
    struct Triplet {
        let name: String
        let center: BodyJoint
        let first: BodyJoint
        let third: BodyJoint
    }

    static let angleTriplets: [Triplet] = [
        Triplet(name: "Left Elbow", center: .leftElbow, first: .leftShoulder, third: .leftWrist),
        Triplet(name: "Right Elbow", center: .rightElbow, first: .rightShoulder, third: .rightWrist),
        Triplet(name: "Left Shoulder", center: .leftShoulder, first: .neck, third: .leftElbow),
        Triplet(name: "Right Shoulder", center: .rightShoulder, first: .neck, third: .rightElbow),
        Triplet(name: "Left Knee", center: .leftKnee, first: .leftHip, third: .leftAnkle),
        Triplet(name: "Right Knee", center: .rightKnee, first: .rightHip, third: .rightAnkle),
    ]

    static func calculateAngles(from body: DetectedBody) -> [JointAngle] {
        var results: [JointAngle] = []

        for triplet in angleTriplets {
            guard let angle = angleDegrees(
                center: triplet.center,
                first: triplet.first,
                third: triplet.third,
                in: body
            ) else { continue }

            results.append(JointAngle(
                name: triplet.name,
                degrees: angle.degrees,
                jointPosition: angle.position
            ))
        }

        return results
    }

    private static func angleDegrees(
        center: BodyJoint,
        first: BodyJoint,
        third: BodyJoint,
        in body: DetectedBody
    ) -> (degrees: CGFloat, position: CGPoint)? {
        guard let b = body.joints[center],
              let a = body.joints[first],
              let c = body.joints[third] else { return nil }

        let v1 = CGPoint(x: a.location.x - b.location.x, y: a.location.y - b.location.y)
        let v2 = CGPoint(x: c.location.x - b.location.x, y: c.location.y - b.location.y)

        let dot = v1.x * v2.x + v1.y * v2.y
        let mag1 = sqrt(v1.x * v1.x + v1.y * v1.y)
        let mag2 = sqrt(v2.x * v2.x + v2.y * v2.y)

        guard mag1 > 0.0001, mag2 > 0.0001 else { return nil }

        var cosAngle = dot / (mag1 * mag2)
        cosAngle = max(-1.0, min(1.0, cosAngle))
        let angle = acos(cosAngle) * 180.0 / .pi

        return (angle, b.location)
    }
}
