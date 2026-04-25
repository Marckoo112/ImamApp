//
//  BodyPositionGuideView.swift
//  PoonaApp
//

import SwiftUI

struct BodyPositionGuideView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Image(systemName: "figure.stand")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)

                Text("Position your full body so it is visible on camera")
                    .font(.poonaTitle)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
        }
    }
}

#Preview {
    BodyPositionGuideView()
}
