import SwiftUI

// ini screen pertama yang muncul waktu app dibuka

struct splashScreen: View {
    @State private var logoScale: CGFloat    = 0.7
    @State private var contentOpacity: Double = 0

    @State private var selectedHand = ""
    @State private var selectedStroke = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

                // background gradientnya biar ga polos banget
                // background solid biar ga keramaian
                Color.red.opacity(0.1)
                .frame(height: 460)
                .ignoresSafeArea()

                
                ZStack {
                    Circle()
                        .fill(Color.appBlue.opacity(0.18))
                        .frame(width: 300, height: 300)
                        .blur(radius: 70)
                        .offset(x: -110, y: -80)

                    Circle()
                        .fill(Color.appPink.opacity(0.14))
                        .frame(width: 220, height: 220)
                        .blur(radius: 60)
                        .offset(x: 130, y: -40)
                }
                .ignoresSafeArea()

                // layout utama
                VStack(spacing: 0) {
                    Spacer()

                    BadmintonLogoView(size: 300)
                        .scaleEffect(logoScale)
                        .opacity(contentOpacity)


                    Spacer().frame(height: 52)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("PRECISION TRAINING")
                            .font(.system(size: 11, weight: .bold))
                            .kerning(2.2)
                            .foregroundStyle(Color.appOrange)

                        Text("Improve your\nstroke")
                            .font(.system(size: 40, weight: .bold))
                            .lineSpacing(2)

                        Text("Level up your strokes with simple drills, real-time feedback, and personalized coaching designed for casual players.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 28)
                    .opacity(contentOpacity)
//                  

                    Spacer()

                    NavigationLink {
                        choseHand(selectedHand: $selectedHand, selectedStroke: $selectedStroke)
                    } label: {
                        Text("Start Training")
                    }
                    .buttonStyle(GradientButtonStyle())
                    .cornerRadius(30)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 50)
                    .opacity(contentOpacity)
                  
                }
            }
            .background(Color(.systemBackground))
            .onAppear {
                logoScale      = 1.4
                contentOpacity = 1.0
            }
        }
    }
}


struct BadmintonLogoShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        let corkLeft = CGPoint(x: w * 0.35, y: h * 0.75)
        let corkRight = CGPoint(x: w * 0.65, y: h * 0.75)
        let topL = CGPoint(x: w * 0.15, y: h * 0.15)
        let topR = CGPoint(x: w * 0.85, y: h * 0.15)
        
        // 1. Cork base
        path.move(to: corkLeft)
        path.addCurve(to: corkRight, 
                      control1: CGPoint(x: w * 0.35, y: h * 0.95), 
                      control2: CGPoint(x: w * 0.65, y: h * 0.95))
        
        // Garis batas cork atas
        path.addLine(to: corkLeft)
        
        // 2. Garis luar bulu (Outer Feathers)
        path.move(to: corkLeft)
        path.addLine(to: topL)
        
        // Tepi atas bergelombang (Wavy top edge)
        path.addQuadCurve(to: CGPoint(x: w * 0.38, y: h * 0.20), control: CGPoint(x: w * 0.26, y: h * 0.13))
        path.addQuadCurve(to: CGPoint(x: w * 0.62, y: h * 0.20), control: CGPoint(x: w * 0.50, y: h * 0.13))
        path.addQuadCurve(to: topR, control: CGPoint(x: w * 0.74, y: h * 0.13))
        
        path.addLine(to: corkRight)
        
        // 3. Garis bulu bagian dalam (Inner feather lines)
        path.move(to: CGPoint(x: w * 0.45, y: h * 0.75))
        path.addLine(to: CGPoint(x: w * 0.38, y: h * 0.20))
        
        path.move(to: CGPoint(x: w * 0.55, y: h * 0.75))
        path.addLine(to: CGPoint(x: w * 0.62, y: h * 0.20))
        
        // 4. Sabuk pengikat bulu (Horizontal bands) yang melengkung
        path.move(to: CGPoint(x: w * 0.23, y: h * 0.40))
        path.addQuadCurve(to: CGPoint(x: w * 0.77, y: h * 0.40), control: CGPoint(x: w * 0.5, y: h * 0.45))
        
        path.move(to: CGPoint(x: w * 0.29, y: h * 0.58))
        path.addQuadCurve(to: CGPoint(x: w * 0.71, y: h * 0.58), control: CGPoint(x: w * 0.5, y: h * 0.62))
        
        return path
    }
}

struct BadmintonLogoView: View {
    var size: CGFloat = 130

    var body: some View {
        BadmintonLogoShape()
            .stroke(Color.red, style: StrokeStyle(lineWidth: size * 0.04, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(30)) 
    }
}


#Preview {
    splashScreen()
}
