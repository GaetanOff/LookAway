import SwiftUI

@main
struct LookAwayApp: App {
    @ObservedObject var timerManager = TimerManager.shared
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
