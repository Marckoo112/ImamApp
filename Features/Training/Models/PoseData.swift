//
//  PoseData.swift
//  PoonaApp
//
//  Created by Sande Effindi on 16/04/26.
//

import Foundation
import Vision

enum BodyJoint: String, Codable, CaseIterable {
    case nose
    case leftEye, rightEye
    case leftEar, rightEar
    case leftShoulder, rightShoulder
    case leftElbow, rightElbow
    case leftWrist, rightWrist
    case neck, root
    case leftHip, rightHip
    case leftKnee, rightKnee
    case leftAnkle, rightAnkle

    nonisolated var visionJointName: VNHumanBodyPoseObservation.JointName {
        switch self {
        case .nose: .nose
        case .leftEye: .leftEye
        case .rightEye: .rightEye
        case .leftEar: .leftEar
        case .rightEar: .rightEar
        case .leftShoulder: .leftShoulder
        case .rightShoulder: .rightShoulder
        case .leftElbow: .leftElbow
        case .rightElbow: .rightElbow
        case .leftWrist: .leftWrist
        case .rightWrist: .rightWrist
        case .neck: .neck
        case .root: .root
        case .leftHip: .leftHip
        case .rightHip: .rightHip
        case .leftKnee: .leftKnee
        case .rightKnee: .rightKnee
        case .leftAnkle: .leftAnkle
        case .rightAnkle: .rightAnkle
        }
    }
}

struct PoseFrame: Codable, Sendable {
    let timestamp: TimeInterval
    let boundingBox: CGRect
    let joints: [BodyJoint: CGPoint]

    enum CodingKeys: String, CodingKey {
        case timestamp, boundingBox, joints
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(boundingBox, forKey: .boundingBox)
        try container.encode(Dictionary(uniqueKeysWithValues: joints.map { ($0.key.rawValue, $0.value) }), forKey: .joints)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        boundingBox = try container.decode(CGRect.self, forKey: .boundingBox)
        let jointDict = try container.decode([String: CGPoint].self, forKey: .joints)
        joints = Dictionary(uniqueKeysWithValues:
            jointDict.compactMap { key, value in
                guard let joint = BodyJoint(rawValue: key) else { return nil }
                return (joint, value)
            }
        )
    }

    init(timestamp: TimeInterval, boundingBox: CGRect, joints: [BodyJoint: CGPoint]) {
        self.timestamp = timestamp
        self.boundingBox = boundingBox
        self.joints = joints
    }
}

struct SessionData {
    let id: UUID
    let trainingType: TrainingModule.TrainingType
    let startTime: Date
    let endTime: Date
    let poseFrames: [PoseFrame]

    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }

    var repCount: Int { 0 }

    func encodePoseFrames() -> Data? {
        try? JSONEncoder().encode(poseFrames)
    }

    static func decodePoseFrames(from data: Data) -> [PoseFrame]? {
        try? JSONDecoder().decode([PoseFrame].self, from: data)
    }
}
