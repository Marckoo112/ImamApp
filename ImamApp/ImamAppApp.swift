import SwiftUI

@main
struct ImamAppApp: App {
    @State private var appState = AppState()

    // showSplash selalu true waktu app dibuka, dikontrol di sini
    @State private var showSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                // splash screen muncul di atas setiap launch
                if showSplash {
                    AppSplashScreen {
                        // setelah animasi selesai, sembunyikan splash
                        withAnimation(.easeOut(duration: 0.3)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
                
                // konten utama di balik splash
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
}
