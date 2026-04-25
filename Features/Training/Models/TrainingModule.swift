//
//  TrainingModule.swift
//  PoonaApp
//
//  Created by Sande Effendi on 11/04/26.
//

import Foundation

struct TrainingModule: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let imageName: String?
    let type: TrainingType

    enum TrainingType {
        case forehand
        case backhand
        case comingsoon
    }
}

extension TrainingModule {
    static let availableModules: [TrainingModule] = [

        // forehand training module
        TrainingModule(
            title: "Forehand Training",
            imageName: nil,
            type: .forehand
        ),

        // backhand training module
        TrainingModule(
            title: "Backhand Training",
            imageName: nil,
            type: .backhand
        ),

        TrainingModule(title: "Coming Soon", imageName: nil, type: .comingsoon),
    ]

}
