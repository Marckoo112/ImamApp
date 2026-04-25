//import SwiftUI
//
//// view buat milih tangan kanan atau kiri
//
//struct choseHand: View {
//    @Binding var selectedHand: String
//    @Binding var selectedStroke: String
//    
//    @StateObject private var viewModel = OnboardingViewModel()
//    
//    var body: some View {
//        ZStack {
//            // Global Ice Blue Background
//            Color(uiColor: .systemBackground).ignoresSafeArea()
//            Color.appBlue.opacity(0.06).ignoresSafeArea()
//            
//            ScrollView {
//                VStack(spacing: 32) {
//                    
//                    // header dengan logo
//                    VStack(spacing: 20) {
//                        BadmintonLogoView(size: 180)
//                            .padding(.top, 20)
//                        
//                        VStack(spacing: 8) {
//                            Text("Gameplay Hand")
//                                .font(.system(.title, design: .rounded))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.primary)
//                            
//                            Text(
//                                "Select your dominant hand to personalize your training tracking and drills."
//                            )
//                            .font(.subheadline)
//                            .foregroundStyle(.secondary)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal, 40)
//                        }
//                    }
//                    
//                    // pilihan tangan dari Data Model
//                    VStack(spacing: 16) {
//                        ForEach(viewModel.handOptions) { option in
//                            let isSelected = selectedHand == option.value
//                            
//                            Button(action: { selectedHand = option.value }) {
//                                HStack {
//                                    // Tampilkan icon di kiri untuk Left Hand, dikanan untuk Right Hand
//                                    if option.value == "Left Hand" {
//                                        Image(systemName: option.sysImage)
//                                            .rotationEffect(.degrees(option.rotationDegrees))
//                                            .font(.system(size: 30))
//                                            .foregroundStyle(isSelected ? Color.appBlue : .gray)
//                                        Spacer()
//                                    }
//                                    
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text(option.title)
//                                            .font(.system(size: 18, weight: .semibold))
//                                            .foregroundStyle(isSelected ? Color.appBlue : .primary)
//                                        Text(option.subtitle)
//                                            .font(.system(size: 13))
//                                            .foregroundStyle(isSelected ? Color.appBlue.opacity(0.8) : .secondary)
//                                            .lineLimit(2)
//                                    }
//                                    
//                                    if option.value == "Right Hand" {
//                                        Spacer()
//                                        Image(systemName: option.sysImage)
//                                            .rotationEffect(.degrees(option.rotationDegrees))
//                                            .font(.system(size: 30))
//                                            .foregroundStyle(isSelected ? Color.appBlue : .gray)
//                                    }
//                                }
//                                .padding(.horizontal, 24)
//                                .frame(height: 96)
//                                .background(isSelected ? Color.appBlue.opacity(0.1) : Color(uiColor: .systemBackground))
//                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                                        .stroke(isSelected ? Color.appBlue : Color.clear, lineWidth: 2)
//                                )
//                            }
//                            .buttonStyle(.plain)
//                        }
//                    }
//                    .padding(.horizontal, 32)
//                }
//            }
//            .scrollIndicators(.hidden)
//            .safeAreaInset(edge: .bottom) {
//                NavigationLink {
//                    StrokeView( selectedStroke: $selectedStroke)
//                } label: {
//                    Text("Continue")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .controlSize(.large)
//                .tint(.appBlue)
//                .disabled(selectedHand.isEmpty)
//                .padding(.horizontal, 24)
//                .padding(.vertical, 16)
//            }
//            .navigationTitle("Setup")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//    
//    #Preview {
//        choseHand_Preview()
//    }
//    
//    private struct choseHand_Preview: View {
//        @State private var selectedHand: String = ""
//        @State private var selectedStroke: String = ""
//        
//        var body: some View {
//            NavigationStack {
//                choseHand(selectedHand: $selectedHand, selectedStroke: $selectedStroke)
//            }
//        }
//    }
//}
