//
//  BackhandView.swift
//  PoonaApp
//
//  Created by Sande Effindi on 14/04/26.
//

import SwiftUI

struct BackhandView: View {
    var body: some View {
        ZStack {
            Color.poonaBackground.ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Text("Backhand Training")
                    .font(.poonaLargeTitle)

                Text("Position yourself in front of the camera and start your session")
                    .font(.poonaBodySecondary)
                    .foregroundStyle(Color.poonaAccent)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)

                NavigationLink(destination: TrainingSetupView()) {
                    Text("Start Session")
                        .font(.poonaCTALabel)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.md)
                        .background(
                            Color.poonaAccent,
                            in: RoundedRectangle(cornerRadius: Radius.full)
                        )
                }
                .padding(.horizontal, Spacing.xl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    BackhandView()
}
