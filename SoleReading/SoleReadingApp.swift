import SwiftUI
import GoogleMobileAds

@main
struct SoleReadingApp: App {
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
