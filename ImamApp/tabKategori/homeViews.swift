import SwiftUI

struct homeViews: View {
    @State private var isShowCamera: Bool = false
    @AppStorage("selectedHand") var selectedHand: String = ""
    @AppStorage("selectedStroke") var selectedStroke: String = ""

    @State private var showStrokePicker = false
    @State private var showHandPicker = false
    
    var body: some View {

        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    //Headline
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Welcome Back")
                                .font(.headline)

                            Text("Ready to improve your swing today?")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Image(systemName: "figure.badminton")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(20)
                    
                    // Overview
                    Text("Overview")
                        .font(.headline)
                        .foregroundColor(.gray)

                    HStack(spacing: 20) {

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "figure.badminton")
                                Text("Sessions")
                            }
                            .foregroundColor(.blue)

                            Text("0")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                Text("Avg Score")
                            }
                            .foregroundColor(.orange)

                            Text("--")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(20)
                    }
                    
                    // Chose hand and stroke
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training Mode")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(8)
                        
                        HStack(spacing: 12) {
                            
                            Button {
                                showStrokePicker = true
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Chose Stroke")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("\(selectedStroke.capitalized) ▼")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(20)
                            }
                            
                            Button {
                                showHandPicker = true
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Chose Hand")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("\(selectedHand) ▼")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(20)
                            }
                        .sheet(isPresented: $showStrokePicker) {
                            StrokePickerSheet(selectedStroke: $selectedStroke)
                        }
                        .sheet(isPresented: $showHandPicker) {
                            HandPickerSheet(selectedHand: $selectedHand)
                        }
                        }
                    }
                }
                .padding(32)
            }
            .scrollIndicators(.hidden)
            

            Button {
                isShowCamera.toggle()
            } label: {
                Text("Start New Training")
            }
            .buttonStyle(GradientButtonStyle())
            .cornerRadius(30)
            .padding(.horizontal, 28)
            .padding(.bottom)
        }
        .fullScreenCover(isPresented: $isShowCamera) {
            LiveCameraView()
        }
    }
}

#Preview {
    homeViews()
}
