import SwiftUI

// view buat milih jenis pukulan (backhand / forehand)

struct StrokeView: View {
    @AppStorage("selectedHand") var savedHand: String = ""
    @AppStorage("selectedStroke") var savedStroke: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Binding var selectedHand: String
    @Binding var selectedStroke: String

    var body: some View {
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
                
                // pilihan stroke berdasarkan referensi design
                VStack(spacing: 16) {
                    Button(action: { selectedStroke = "Back Hand" }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Back Hand")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(selectedStroke == "Back Hand" ? Color.red : .primary)
                                Text("Focus on control and cross-court balance")
                                    .font(.system(size: 13))
                                    .foregroundStyle(selectedStroke == "Back Hand" ? Color.red.opacity(0.8) : .secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "figure.badminton.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(selectedStroke == "Back Hand" ? Color.red : .gray)
                        }
                        .padding(.horizontal, 24)
                        .frame(height: 96)
                        .background(selectedStroke == "Back Hand" ? Color.red.opacity(0.1) : Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(selectedStroke == "Back Hand" ? Color.red : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(action: { selectedStroke = "Fore Hand" }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Fore Hand")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(selectedStroke == "Fore Hand" ? Color.red : .primary)
                                Text("Standard tracking for the dominant right side")
                                    .font(.system(size: 13))
                                    .foregroundStyle(selectedStroke == "fore" ? Color.red.opacity(0.8) : .secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "figure.badminton.circle.fill")
                                .scaleEffect(x: -1, y: 1)
                                .font(.system(size: 40))
                                .foregroundStyle(selectedStroke == "Fore Hand" ? Color.red : .gray)
                        }
                        .padding(.horizontal, 24)
                        .frame(height: 96)
                        .background(selectedStroke == "Fore Hand" ? Color.red.opacity(0.1) : Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(selectedStroke == "Fore Hand" ? Color.red : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }

                .padding(.horizontal, 32)
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                permissionCamera()
                    .onAppear {
                        savedHand = selectedHand
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
            .tint(.red)
            .disabled(selectedStroke.isEmpty)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
           
        }
        .navigationTitle("Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Preview

#Preview {
    StrokeView_Preview()
}

private struct StrokeView_Preview: View {
    @State private var selectedStroke: String = ""
    @State private var selectedHand: String = ""
    
    var body: some View {
        NavigationStack {
            StrokeView(selectedHand: $selectedHand, selectedStroke: $selectedStroke)
        }
    }
}
