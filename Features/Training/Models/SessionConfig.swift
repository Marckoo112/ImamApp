//
//  SessionConfig.swift
//  PoonaApp
//

import Foundation

struct SessionConfig: Equatable {
    let duration: TimeInterval
    var trainingType: TrainingModule.TrainingType = .forehand

    static let presets: [SessionConfig] = [
        SessionConfig(duration: 30),
        SessionConfig(duration: 60),
        SessionConfig(duration: 120),
        SessionConfig(duration: 300),
    ]

    static let `default` = SessionConfig(duration: 60)

    var displayText: String {
        if duration < 60 {
            return "\(Int(duration)) seconds"
        } else if duration == 60 {
            return "1 minute"
        } else {
            return "\(Int(duration / 60)) minutes"
        }
    }
}
