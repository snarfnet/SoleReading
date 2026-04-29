import SwiftUI

struct HomeView: View {
    @State private var pulseAnimation = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.14, blue: 0.11),
                        Color(red: 0.04, green: 0.07, blue: 0.06)
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 20) {
                        Image("FootImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 300)
                            .scaleEffect(pulseAnimation ? 1.03 : 1.0)
                            .animation(
                                .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                                value: pulseAnimation
                            )

                        VStack(spacing: 6) {
                            Text("足つぼ健康占い")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.88, green: 0.76, blue: 0.38))
                            Text("Sole Reading")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundStyle(Color(red: 0.50, green: 0.70, blue: 0.55))
                                .tracking(4)
                        }
                    }

                    Spacer().frame(height: 36)

                    Text("あなたの足裏から\n体の声を聴く")
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 0.78, green: 0.84, blue: 0.78))
                        .lineSpacing(6)

                    Spacer()

                    NavigationLink(destination: FootSelectionView()) {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 20))
                            Text("診断を始める")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.90, green: 0.78, blue: 0.40),
                                    Color(red: 0.76, green: 0.58, blue: 0.24)
                                ],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: Color(red: 0.88, green: 0.76, blue: 0.38).opacity(0.30),
                            radius: 14, y: 5
                        )
                    }
                    .padding(.horizontal, 32)

                    Spacer().frame(height: 36)

                    Text("東洋医学の足つぼ反射区に基づき、\n足裏の色から体調を占います")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 0.38, green: 0.50, blue: 0.40))
                        .lineSpacing(4)

                    Spacer().frame(height: 28)
                }
                .padding(.horizontal, 24)
            }
            .onAppear { pulseAnimation = true }
        }
    }
}

// MARK: - Foot Illustration

struct FootIllustration: View {
    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.88, green: 0.76, blue: 0.38).opacity(0.07))
                .frame(width: 110, height: 160)

            FootShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.22, green: 0.40, blue: 0.28),
                            Color(red: 0.13, green: 0.24, blue: 0.18)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )

            FootShape()
                .stroke(Color(red: 0.88, green: 0.76, blue: 0.38).opacity(0.55), lineWidth: 1.5)

            FootZoneLines()
                .stroke(Color(red: 0.88, green: 0.76, blue: 0.38).opacity(0.20), lineWidth: 0.8)
        }
    }
}

struct FootShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let x = rect.minX, y = rect.minY

        p.move(to: CGPoint(x: x + w*0.25, y: y + h*0.96))
        p.addQuadCurve(to: CGPoint(x: x + w*0.75, y: y + h*0.96),
                       control: CGPoint(x: x + w*0.50, y: y + h*1.05))
        p.addQuadCurve(to: CGPoint(x: x + w*0.88, y: y + h*0.36),
                       control: CGPoint(x: x + w*0.93, y: y + h*0.68))
        p.addLine(to: CGPoint(x: x + w*0.84, y: y + h*0.22))
        p.addQuadCurve(to: CGPoint(x: x + w*0.74, y: y + h*0.20),
                       control: CGPoint(x: x + w*0.81, y: y + h*0.12))
        p.addQuadCurve(to: CGPoint(x: x + w*0.63, y: y + h*0.18),
                       control: CGPoint(x: x + w*0.70, y: y + h*0.10))
        p.addQuadCurve(to: CGPoint(x: x + w*0.51, y: y + h*0.15),
                       control: CGPoint(x: x + w*0.59, y: y + h*0.07))
        p.addQuadCurve(to: CGPoint(x: x + w*0.37, y: y + h*0.15),
                       control: CGPoint(x: x + w*0.46, y: y + h*0.05))
        p.addQuadCurve(to: CGPoint(x: x + w*0.16, y: y + h*0.24),
                       control: CGPoint(x: x + w*0.25, y: y + h*0.06))
        p.addQuadCurve(to: CGPoint(x: x + w*0.10, y: y + h*0.50),
                       control: CGPoint(x: x + w*0.04, y: y + h*0.34))
        p.addQuadCurve(to: CGPoint(x: x + w*0.18, y: y + h*0.78),
                       control: CGPoint(x: x + w*0.03, y: y + h*0.64))
        p.addQuadCurve(to: CGPoint(x: x + w*0.25, y: y + h*0.96),
                       control: CGPoint(x: x + w*0.14, y: y + h*0.88))
        p.closeSubpath()
        return p
    }
}

struct FootZoneLines: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let x = rect.minX, y = rect.minY
        for yRatio in [0.22, 0.38, 0.55, 0.70, 0.82] as [CGFloat] {
            p.move(to: CGPoint(x: x + w*0.10, y: y + h*yRatio))
            p.addLine(to: CGPoint(x: x + w*0.90, y: y + h*yRatio))
        }
        return p
    }
}
