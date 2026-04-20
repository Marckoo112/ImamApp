//
//  OnboardingRules.swift
//  ImamApp
//
//  Created by Imam on 19/04/26.
//

import SwiftUI

struct OnboardingRules: View {
    
    @State private var selectedHand: String = ""
    @State private var selectedStroke: String = ""
    
    var body: some View {
        NavigationStack {
            choseHand(
                selectedHand: $selectedHand,
                selectedStroke: $selectedStroke
            )
        }
    }
}
