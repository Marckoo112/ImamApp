import SwiftUI

struct mainTabView: View {
    var body: some View {

        TabView {
            homeViews()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            historyView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
    }

}

#Preview {
    mainTabView()
}
