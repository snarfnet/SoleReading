import SwiftUI

struct AnalysisView: View {
    let image: UIImage
    let footSide: FootSide

    @State private var isAnalyzing = false
    @State private var analysisResult: FootAnalysis?
    @State private var scanProgress: CGFloat = 0
    @State private var scanLineY: CGFloat = 0
    @State private var navigateToResult = false

    var zones: [ReflexologyZone] { ReflexologyZone.zones(for: footSide) }

    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.10, blue: 0.08).ignoresSafeArea()

            VStack(spacing: 0) {
                // Photo + overlay
                GeometryReader { geo in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        GeometryReader { imgGeo in
                            let fitted = fittedSize(image: image, in: imgGeo.size)
                            let ox = (imgGeo.size.width - fitted.width) / 2
                            let oy = (imgGeo.size.height - fitted.height) / 2

                            ForEach(zones) { zone in
                                let zr = CGRect(
                                    x: ox + zone.displayRect.minX * fitted.width,
                                    y: oy + zone.displayRect.minY * fitted.height,
                                    width: zone.displayRect.width * fitted.width,
                                    height: zone.displayRect.height * fitted.height
                                )
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(zone.zoneColor)
                                    .frame(width: zr.width, height: zr.height)
                                    .position(x: zr.midX, y: zr.midY)

                                Text(zone.nameJP)
                                    .font(.system(size: max(7, zr.height * 0.32), weight: .semibold))
                                    .foregroundStyle(.white)
                                    .shadow(color: .black.opacity(0.9), radius: 2)
                                    .position(x: zr.midX, y: zr.midY)
                            }

                            // Scan line
                            if isAnalyzing {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.88, green: 0.76, blue: 0.38).opacity(0),
                                                Color(red: 0.88, green: 0.76, blue: 0.38),
                                                Color(red: 0.88, green: 0.76, blue: 0.38).opacity(0)
                                            ],
                                            startPoint: .leading, endPoint: .trailing
                                        )
                                    )
                                    .frame(width: fitted.width, height: 3)
                                    .position(x: imgGeo.size.width / 2,
                                              y: oy + scanLineY * fitted.height)
                                    .animation(.linear(duration: 1.8), value: scanLineY)
                            }
                        }
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height * 0.56)
                .clipped()

                // Bottom panel
                VStack(spacing: 20) {
                    if isAnalyzing {
                        VStack(spacing: 10) {
                            ProgressView(value: scanProgress)
                                .progressViewStyle(.linear)
                                .tint(Color(red: 0.88, green: 0.76, blue: 0.38))
                                .padding(.horizontal, 32)
                                .animation(.linear(duration: 2.0), value: scanProgress)

                            Text("足裏を解析中... / Analyzing...")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(red: 0.50, green: 0.68, blue: 0.53))
                        }
                    } else if analysisResult != nil {
                        Text("診断が完了しました")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color(red: 0.50, green: 0.68, blue: 0.53))
                    } else {
                        VStack(spacing: 6) {
                            Text("\(footSide.rawValue)の反射区マップ")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color(red: 0.88, green: 0.76, blue: 0.38))
                            Text("色付きの枠が各足つぼゾーンを示しています")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(red: 0.48, green: 0.60, blue: 0.50))
                                .multilineTextAlignment(.center)
                        }
                    }

                    if analysisResult != nil {
                        Button { navigateToResult = true } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "chart.bar.doc.horizontal")
                                Text("診断結果を見る")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.90, green: 0.78, blue: 0.40), Color(red: 0.76, green: 0.58, blue: 0.24)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal, 24)
                    } else if !isAnalyzing {
                        Button { startAnalysis() } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "waveform.path.ecg")
                                Text("足裏を診断する")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.90, green: 0.78, blue: 0.40), Color(red: 0.76, green: 0.58, blue: 0.24)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.vertical, 24)
                .background(Color(red: 0.10, green: 0.16, blue: 0.12))
            }
        }
        .navigationTitle("反射区マップ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(isPresented: $navigateToResult) {
            if let result = analysisResult {
                ResultView(analysis: result)
            }
        }
    }

    private func fittedSize(image: UIImage, in container: CGSize) -> CGSize {
        let imgR = image.size.width / image.size.height
        let conR = container.width / container.height
        if imgR > conR {
            return CGSize(width: container.width, height: container.width / imgR)
        } else {
            return CGSize(width: container.height * imgR, height: container.height)
        }
    }

    private func startAnalysis() {
        isAnalyzing = true
        scanProgress = 0
        scanLineY = 0

        withAnimation(.linear(duration: 2.0)) { scanProgress = 1.0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 1.8)) { scanLineY = 1.0 }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let result = ImageAnalyzer.analyze(image: image, footSide: footSide)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                analysisResult = result
                isAnalyzing = false
            }
        }
    }
}
