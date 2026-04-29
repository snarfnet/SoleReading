import UIKit
import CoreImage

struct ZoneAnalysis: Identifiable {
    let id: Int
    let zone: ReflexologyZone
    let avgColor: UIColor
    let score: Int
    let messageJP: String
    let messageEN: String
}

struct FootAnalysis {
    let zoneResults: [ZoneAnalysis]
    let overallScore: Int
    let footSide: FootSide

    var scoreLabel: String {
        switch overallScore {
        case 90...: return "絶好調"
        case 80..<90: return "良好"
        case 70..<80: return "まずまず"
        default: return "要ケア"
        }
    }

    var scoreLabelEN: String {
        switch overallScore {
        case 90...: return "Excellent"
        case 80..<90: return "Good"
        case 70..<80: return "Fair"
        default: return "Needs Care"
        }
    }
}

class ImageAnalyzer {
    static func analyze(image: UIImage, footSide: FootSide) -> FootAnalysis {
        let zones = ReflexologyZone.zones(for: footSide)
        let sampledColors = zones.map { sampleAverageColor(from: image, rect: $0.sampleRect) }

        let avgR = sampledColors.map { $0.r }.reduce(0, +) / CGFloat(sampledColors.count)
        let avgG = sampledColors.map { $0.g }.reduce(0, +) / CGFloat(sampledColors.count)
        let avgB = sampledColors.map { $0.b }.reduce(0, +) / CGFloat(sampledColors.count)

        let results = zones.enumerated().map { idx, zone in
            score(zone: zone, color: sampledColors[idx], footAvg: (avgR, avgG, avgB))
        }

        let overall = results.map { $0.score }.reduce(0, +) / results.count
        return FootAnalysis(zoneResults: results, overallScore: overall, footSide: footSide)
    }

    private static func score(
        zone: ReflexologyZone,
        color: UIColor,
        footAvg: (CGFloat, CGFloat, CGFloat)
    ) -> ZoneAnalysis {
        let r = color.r
        let g = color.g
        let b = color.b
        let brightness = (r + g + b) / 3
        let avgBrightness = (footAvg.0 + footAvg.1 + footAvg.2) / 3
        let deltaR = r - footAvg.0
        let deltaBrightness = brightness - avgBrightness

        let sc: Int
        let msgJP: String
        let msgEN: String

        if brightness > 0.88 {
            sc = 58
            msgJP = "冷えや血流不足のサインかも。足を温めましょう"
            msgEN = "Signs of coldness detected. Try warming your feet"
        } else if deltaR > 0.10 {
            sc = 70
            msgJP = "疲労や緊張が蓄積しているようです。休息を取りましょう"
            msgEN = "Fatigue or tension detected. Rest is recommended"
        } else if deltaR < -0.10 || deltaBrightness < -0.10 {
            sc = 65
            msgJP = "エネルギーが低下気味。栄養補給と睡眠を意識しましょう"
            msgEN = "Low energy detected. Focus on nutrition and sleep"
        } else if abs(deltaR) < 0.04 && abs(deltaBrightness) < 0.04 {
            sc = 95
            msgJP = "とても良好な状態です！このまま維持しましょう"
            msgEN = "Excellent condition! Keep it up"
        } else {
            sc = 82
            msgJP = "概ね良好。定期的なケアでさらに良くなります"
            msgEN = "Generally good. Regular care will help further"
        }

        return ZoneAnalysis(id: zone.id, zone: zone, avgColor: color,
                            score: sc, messageJP: msgJP, messageEN: msgEN)
    }

    private static func sampleAverageColor(from image: UIImage, rect: CGRect) -> UIColor {
        guard let cgImage = image.cgImage else { return .systemGray }

        let w = CGFloat(cgImage.width)
        let h = CGFloat(cgImage.height)
        let cropRect = CGRect(
            x: rect.minX * w, y: rect.minY * h,
            width: rect.width * w, height: rect.height * h
        ).integral

        guard cropRect.width > 2, cropRect.height > 2,
              let cropped = cgImage.cropping(to: cropRect) else { return .systemGray }

        let ciImage = CIImage(cgImage: cropped)
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [
            kCIInputImageKey: ciImage,
            kCIInputExtentKey: CIVector(cgRect: ciImage.extent)
        ]), let output = filter.outputImage else { return .systemGray }

        let context = CIContext(options: [.useSoftwareRenderer: false])
        var pixel = [UInt8](repeating: 0, count: 4)
        context.render(output, toBitmap: &pixel, rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())

        return UIColor(red: CGFloat(pixel[0]) / 255,
                       green: CGFloat(pixel[1]) / 255,
                       blue: CGFloat(pixel[2]) / 255, alpha: 1)
    }
}

extension UIColor {
    var r: CGFloat { var v: CGFloat = 0; getRed(&v, green: nil, blue: nil, alpha: nil); return v }
    var g: CGFloat { var v: CGFloat = 0; getRed(nil, green: &v, blue: nil, alpha: nil); return v }
    var b: CGFloat { var v: CGFloat = 0; getRed(nil, green: nil, blue: &v, alpha: nil); return v }
}
