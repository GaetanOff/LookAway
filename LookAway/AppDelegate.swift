import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        let timerManager = TimerManager.shared
        statusBarController = StatusBarController(timerManager: timerManager)
    }
}
