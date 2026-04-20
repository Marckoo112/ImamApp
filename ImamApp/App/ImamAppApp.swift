//
//  ImamAppApp.swift
//  ImamApp
//
//  Created by Imam on 10/04/26.
//

import SwiftUI

@main
struct ImamAppApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                mainTabView()
                    .environment(appState)
            } else {
                splashScreen()
                    .environment(appState)
            }
        }
    }
}
