import Observation
//
//  AppState.swift
//  ImamApp
//
//  Created by Imam on 18/04/26.
//
import SwiftUI

@Observable
final class AppState {
    var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(
                hasCompletedOnboarding,
                forKey: Constants.completedOnboardingkey
            )
        }
    }

    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(
            forKey: Constants.completedOnboardingkey
        )
    }
}
