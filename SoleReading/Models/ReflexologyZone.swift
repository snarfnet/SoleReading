import SwiftUI

enum FootSide: String, CaseIterable {
    case left = "左足"
    case right = "右足"

    var englishName: String {
        switch self {
        case .left: return "Left Foot"
        case .right: return "Right Foot"
        }
    }
}

struct ReflexologyZone: Identifiable {
    let id: Int
    let nameJP: String
    let nameEN: String
    let organJP: String
    let organEN: String
    let sampleRect: CGRect   // Normalized 0-1, y:0=toes, y:1=heel
    let displayRect: CGRect  // Same coords, used for overlay
    let zoneColor: Color

    static func zones(for side: FootSide) -> [ReflexologyZone] {
        [
            ReflexologyZone(
                id: 0, nameJP: "親指", nameEN: "Big Toe",
                organJP: "脳・下垂体", organEN: "Brain & Pituitary",
                sampleRect: CGRect(x: 0.05, y: 0.02, width: 0.28, height: 0.18),
                displayRect: CGRect(x: 0.05, y: 0.02, width: 0.28, height: 0.18),
                zoneColor: Color(red: 0.95, green: 0.35, blue: 0.35).opacity(0.50)
            ),
            ReflexologyZone(
                id: 1, nameJP: "他の指", nameEN: "Other Toes",
                organJP: "副鼻腔・目・耳", organEN: "Sinuses, Eyes & Ears",
                sampleRect: CGRect(x: 0.33, y: 0.02, width: 0.60, height: 0.18),
                displayRect: CGRect(x: 0.33, y: 0.02, width: 0.60, height: 0.18),
                zoneColor: Color(red: 0.95, green: 0.65, blue: 0.20).opacity(0.50)
            ),
            ReflexologyZone(
                id: 2, nameJP: "母指球", nameEN: "Ball of Foot",
                organJP: "心臓・肺", organEN: "Heart & Lungs",
                sampleRect: CGRect(x: 0.05, y: 0.20, width: 0.88, height: 0.17),
                displayRect: CGRect(x: 0.05, y: 0.20, width: 0.88, height: 0.17),
                zoneColor: Color(red: 0.25, green: 0.80, blue: 0.50).opacity(0.50)
            ),
            ReflexologyZone(
                id: 3, nameJP: "土踏まず上部", nameEN: "Upper Arch",
                organJP: "胃・膵臓", organEN: "Stomach & Pancreas",
                sampleRect: CGRect(x: 0.05, y: 0.37, width: 0.72, height: 0.17),
                displayRect: CGRect(x: 0.05, y: 0.37, width: 0.72, height: 0.17),
                zoneColor: Color(red: 0.30, green: 0.60, blue: 0.95).opacity(0.50)
            ),
            ReflexologyZone(
                id: 4, nameJP: "土踏まず中部", nameEN: "Mid Arch",
                organJP: "腎臓・副腎", organEN: "Kidney & Adrenal",
                sampleRect: CGRect(x: 0.05, y: 0.54, width: 0.72, height: 0.15),
                displayRect: CGRect(x: 0.05, y: 0.54, width: 0.72, height: 0.15),
                zoneColor: Color(red: 0.65, green: 0.30, blue: 0.95).opacity(0.50)
            ),
            ReflexologyZone(
                id: 5, nameJP: "土踏まず下部", nameEN: "Lower Arch",
                organJP: "大腸・小腸", organEN: "Intestines",
                sampleRect: CGRect(x: 0.05, y: 0.69, width: 0.72, height: 0.12),
                displayRect: CGRect(x: 0.05, y: 0.69, width: 0.72, height: 0.12),
                zoneColor: Color(red: 0.95, green: 0.45, blue: 0.80).opacity(0.50)
            ),
            ReflexologyZone(
                id: 6, nameJP: "かかと", nameEN: "Heel",
                organJP: "骨盤・坐骨神経", organEN: "Pelvis & Sciatic Nerve",
                sampleRect: CGRect(x: 0.12, y: 0.81, width: 0.76, height: 0.15),
                displayRect: CGRect(x: 0.12, y: 0.81, width: 0.76, height: 0.15),
                zoneColor: Color(red: 0.85, green: 0.72, blue: 0.25).opacity(0.50)
            )
        ]
    }
}
