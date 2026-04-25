//
//  CountdownOverlayView.swift
//  
//

import SwiftUI

struct CountdownOverlayView: View {
    let value: Int

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        Text("\(value)")
            .font(.system(size: 120, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .shadow(radius: 10)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                scale = 0.5
                opacity = 0
                withAnimation(.easeOut(duration: 0.3)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
            .onChange(of: value) { _, _ in
                scale = 0.5
                opacity = 0
                withAnimation(.easeOut(duration: 0.3)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
    }
}

#Preview {
    CountdownOverlayView(value: 3)
}
