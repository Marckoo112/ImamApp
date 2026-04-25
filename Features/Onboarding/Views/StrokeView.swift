import SwiftUI

// view buat milih jenis pukulan (backhand / forehand)

struct StrokeView: View {

    @AppStorage("selectedStroke") var savedStroke: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Binding var selectedStroke: String
    
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            // Global Ice Blue Background
            Color(uiColor: .systemBackground).ignoresSafeArea()
            Color.appBlue.opacity(0.06).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    
                    // header
                    VStack(spacing: 20) {
                        BadmintonLogoView(size: 160)
                            .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Text("Choose Your Stroke")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text(
                                "Select your primary focus for this session to tailor the AI coaching feedback."
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        }
                    }
                    
                    // pilihan stroke berdasarkan data model
                    VStack(spacing: 16) {
                        ForEach(viewModel.strokeOptions) { option in
                            let isSelected = selectedStroke == option.value
                            
                            Button(action: { selectedStroke = option.value }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.title)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(isSelected ? Color.appBlue : .primary)
                                        Text(option.subtitle)
                                            .font(.system(size: 13))
                                            .foregroundStyle(isSelected ? Color.appBlue.opacity(0.8) : .secondary)
                                            .lineLimit(2)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: option.sysImage)
                                        .scaleEffect(x: option.flipHorizontal ? -1 : 1, y: 1)
                                        .font(.system(size: 40))
                                        .foregroundStyle(isSelected ? Color.appBlue : .gray)
                                }
                                .padding(.horizontal, 24)
                                .frame(height: 96)
                                .background(isSelected ? Color.appBlue.opacity(0.1) : Color(uiColor: .systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(isSelected ? Color.appBlue : Color.clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 32)
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom) {
                NavigationLink {
                    permissionCamera()
                        .onAppear {
                            savedStroke = selectedStroke
                            hasCompletedOnboarding = true
                        }
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.appBlue)
                .disabled(selectedStroke.isEmpty)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .navigationTitle("Setup")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    
    #Preview {
        StrokeView_Preview()
    }
    
    private struct StrokeView_Preview: View {
        @State private var selectedStroke: String = ""
        @State private var selectedHand: String = ""
        
        var body: some View {
            NavigationStack {
                StrokeView( selectedStroke: $selectedStroke)
            }
        }
    }
}
