import SwiftUI

// view buat milih tangan kanan atau kiri

struct choseHand: View {
//    @State private var selectedHand: String = ""
//    @State private var selectedStroke: String = ""
    @Binding var selectedHand: String
    @Binding var selectedStroke: String
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {

                // header dengan logo
                VStack(spacing: 20) {
                    BadmintonLogoView(size: 180)
                        .padding(.top, 20)

                    VStack(spacing: 8) {
                        Text("Gameplay Hand")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Text(
                            "Select your dominant hand to personalize your training tracking and drills."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    }
                }

                // pilihan tangan 
                VStack(spacing: 16) {
                    Button(action: { selectedHand = "Left Hand" }) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .rotationEffect(.degrees(270))
                                .font(.system(size: 30))
                                .foregroundStyle(selectedHand == "Left Hand" ? Color.red : .gray)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Left Hand")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(selectedHand == "Left Hand" ? Color.red : .primary)
                                Text("Mirror tracking calibrated for southpaws")
                                    .font(.system(size: 13))
                                    .foregroundStyle(selectedHand == "Left Hand" ? Color.red.opacity(0.8) : .secondary)
                                    .lineLimit(2)
                            }
                            

                        }
                        .padding(.horizontal, 24)
                        .frame(height: 96)
                        .background(selectedHand == "Left Hand" ? Color.red.opacity(0.1) : Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(selectedHand == "Left Hand" ? Color.red : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(action: { selectedHand = "Right Hand" }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Right Hand")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(selectedHand == "Right Hand" ? Color.red : .primary)
                                Text("Tracking for the dominant right side")
                                    .font(.system(size: 13))
                                    .foregroundStyle(selectedHand == "Right Hand" ? Color.red.opacity(0.8) : .secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "hand.raised.fill")
                                .rotationEffect(.degrees(90))
                                .font(.system(size: 30))
                                .foregroundStyle(selectedHand == "Right Hand" ? Color.red : .gray)
                        }
                        .padding(.horizontal, 24)
                        .frame(height: 96)
                        .background(selectedHand == "Right Hand" ? Color.red.opacity(0.1) : Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(selectedHand == "Right Hand" ? Color.red : Color.clear, lineWidth: 2)
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
                StrokeView(selectedHand: $selectedHand, selectedStroke: $selectedStroke)
            } label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.red)
            .disabled(selectedHand.isEmpty)

            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            //
        }
        .navigationTitle("Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}



//#Preview {
//    NavigationStack {
//        choseHand()
//    }
//}

// Preview yang benar
#Preview {
    choseHand_Preview()
}

private struct choseHand_Preview: View {
    @State private var selectedHand: String = ""
    @State private var selectedStroke: String = ""
    
    var body: some View {
        NavigationStack {
            choseHand(selectedHand: $selectedHand, selectedStroke: $selectedStroke)
        }
    }
}
