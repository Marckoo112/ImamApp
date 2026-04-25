//
//  ForehandView.swift
//  PoonaApp
//
//  
//

import SwiftUI

struct ForehandView: View {
    var body: some View {
        ZStack {
            Color.poonaBackground.ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Text("Forehand Training")
                    .font(.poonaLargeTitle)

                Text("Position yourself in front of the camera and start your session")
                    .font(.poonaBodySecondary)
                    .foregroundStyle(Color.primary)
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
    ForehandView()
}
