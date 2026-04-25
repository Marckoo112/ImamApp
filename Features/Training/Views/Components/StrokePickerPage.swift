import SwiftUI


struct StrokePickerPage: View {
    @AppStorage("selectedStroke") var selectedStroke: String = ""
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            // Global Ice Blue Background
            Color(uiColor: .systemBackground).ignoresSafeArea()
            Color.appBlue.opacity(0.06).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {

                
                VStack(spacing: 20) {
                    BadmintonLogoView(size: 150)
                        .padding(.top, 24)

                    VStack(spacing: 8) {
                        Text("Choose Your Stroke")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Text("Select the stroke you want to focus on for this training session.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }

                // pilihan stroke dari view model
                VStack(spacing: 14) {
                    ForEach(viewModel.strokeOptions) { option in
                        let isSelected = selectedStroke == option.value

                        Button(action: { selectedStroke = option.value }) {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(isSelected ? Color.appBlue : .primary)

                                    Text(option.subtitle)
                                        .font(.system(size: 13))
                                        .foregroundStyle(isSelected ? Color.appBlue.opacity(0.8) : .secondary)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                Spacer()

                                Image(systemName: option.sysImage)
                                    .scaleEffect(x: option.flipHorizontal ? -1 : 1, y: 1)
                                    .font(.system(size: 38))
                                    .foregroundStyle(isSelected ? Color.appBlue : .gray)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(isSelected ? Color.appBlue.opacity(0.08) : Color(uiColor: .systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(isSelected ? Color.appBlue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 28)

                Spacer().frame(height: 20)
            }
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
            } label: {
                Text("Save")
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
        .navigationTitle("Stroke")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StrokePickerPage()
    }
}
