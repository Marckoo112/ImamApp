import SwiftUI

// Splash screen yang muncul setiap kali app dibuka
// Didesain elegan dengan solid color dan animasi premium

struct AppSplashScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var isAnimating = false

    var onFinished: () -> Void

    var body: some View {
        ZStack {
            
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            // Hanya menampilkan logo
            BadmintonLogoView(size: 140)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
        }
        .onAppear {
            // Animasi logo masuk
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.8)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }

            // Animasi breathing
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }

            // Setelah 2 detik, panggil callback untuk lanjut
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.3)) {
                    onFinished()
                }
            }
        }
    }
}

#Preview {
    AppSplashScreen(onFinished: {})
}
