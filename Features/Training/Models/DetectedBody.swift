//
//  DetectedBody.swift
//  PoonaApp
//

import CoreGraphics
import Foundation

struct DetectedBody: Equatable {
    struct Joint: Equatable {
        let location: CGPoint
        let confidence: CGFloat
    }

    let joints: [BodyJoint: Joint]

    static let requiredJointsForFullBody: [BodyJoint] = [
        .nose,
        .leftShoulder, .rightShoulder,
        .leftElbow, .rightElbow,
        .leftWrist, .rightWrist,
        .leftHip, .rightHip,
        .leftKnee, .rightKnee,
        .leftAnkle, .rightAnkle,
    ]

    static let confidenceThreshold: CGFloat = 0.5

    var isComplete: Bool {
        Self.requiredJointsForFullBody.allSatisfy { jointName in
            joints[jointName]?.confidence ?? 0 > Self.confidenceThreshold
        }
    }
}
