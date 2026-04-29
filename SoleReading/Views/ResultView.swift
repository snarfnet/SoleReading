import SwiftUI

struct ResultView: View {
    let analysis: FootAnalysis
    @State private var scoreProgress: CGFloat = 0
    @State private var showZones = false

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.14, blue: 0.11).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    // Overall score
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .stroke(Color(red: 0.16, green: 0.26, blue: 0.18), lineWidth: 18)
                                .frame(width: 160, height: 160)

                            Circle()
                                .trim(from: 0, to: scoreProgress * CGFloat(analysis.overallScore) / 100)
                                .stroke(
                                    AngularGradient(
                                        colors: [
                                            Color(red: 0.90, green: 0.78, blue: 0.40),
                                            Color(red: 0.30, green: 0.82, blue: 0.55),
                                            Color(red: 0.90, green: 0.78, blue: 0.40)
                                        ],
                                        center: .center
                                    ),
                                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                                )
                                .frame(width: 160, height: 160)
                                .rotationEffect(.degrees(-90))
                                .animation(.spring(dampingFraction: 0.7).delay(0.2), value: scoreProgress)

                            VStack(spacing: 3) {
                                Text("\(analysis.overallScore)")
                                    .font(.system(size: 46, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(red: 0.92, green: 0.88, blue: 0.80))
                                Text(analysis.scoreLabel)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color(red: 0.88, green: 0.76, blue: 0.38))
                            }
                        }

                        VStack(spacing: 4) {
                            Text("\(analysis.footSide.rawValue)の診断結果")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color(red: 0.90, green: 0.86, blue: 0.80))
                            Text("\(analysis.footSide.englishName)  ·  \(analysis.scoreLabelEN)")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(red: 0.46, green: 0.60, blue: 0.48))
                        }
                    }
                    .padding(.top, 28)

                    Divider()
                        .overlay(Color(red: 0.22, green: 0.32, blue: 0.24))
                        .padding(.horizontal, 24)

                    // Zone cards
                    VStack(spacing: 10) {
                        HStack {
                            Text("各エリアの診断  /  Zone Results")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(red: 0.50, green: 0.68, blue: 0.53))
                            Spacer()
                        }
                        .padding(.horizontal, 24)

                        ForEach(Array(analysis.zoneResults.enumerated()), id: \.offset) { idx, result in
                            ZoneResultCard(result: result)
                                .opacity(showZones ? 1 : 0)
                                .offset(y: showZones ? 0 : 16)
                                .animation(
                                    .spring(dampingFraction: 0.80).delay(Double(idx) * 0.07),
                                    value: showZones
                                )
                        }
                    }

                    // Disclaimer
                    Text("※ この診断は東洋医学の足つぼ理論に基づくエンターテインメントです。医療診断ではありません。\n※ For entertainment purposes only. Not a medical diagnosis.")
                        .font(.system(size: 11))
                        .foregroundStyle(Color(red: 0.36, green: 0.46, blue: 0.38))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 16)

                    AdBannerView()
                        .frame(width: 320, height: 50)
                        .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("診断結果")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.spring(dampingFraction: 0.7).delay(0.1)) { scoreProgress = 1.0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { showZones = true }
        }
    }
}

struct ZoneResultCard: View {
    let result: ZoneAnalysis

    var scoreColor: Color {
        switch result.score {
        case 90...: return Color(red: 0.28, green: 0.82, blue: 0.52)
        case 80..<90: return Color(red: 0.58, green: 0.84, blue: 0.38)
        case 70..<80: return Color(red: 0.92, green: 0.78, blue: 0.28)
        default: return Color(red: 0.92, green: 0.44, blue: 0.34)
        }
    }

    // Strip the .opacity() off the zone color for the solid indicator bar
    var indicatorColor: Color {
        result.zone.zoneColor.opacity(1.0)
    }

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 5)
                .fill(indicatorColor)
                .frame(width: 6, height: 64)

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 4) {
                    Text(result.zone.nameJP)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(red: 0.92, green: 0.88, blue: 0.80))
                    Text("· \(result.zone.organJP)")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(red: 0.50, green: 0.68, blue: 0.53))
                }
                Text(result.zone.organEN)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(red: 0.40, green: 0.54, blue: 0.42))
                Text(result.messageJP)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(red: 0.74, green: 0.80, blue: 0.74))
                    .lineLimit(2)
            }

            Spacer(minLength: 4)

            VStack(spacing: 2) {
                Text("\(result.score)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(scoreColor)
                Text("点")
                    .font(.system(size: 11))
                    .foregroundStyle(scoreColor.opacity(0.70))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(red: 0.13, green: 0.19, blue: 0.15))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 24)
    }
}
