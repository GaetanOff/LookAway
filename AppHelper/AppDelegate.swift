import Cocoa

@main
class AppHelper: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let mainAppBundleID = "fr.gaetandev.LookAway"
        let runningApps = NSWorkspace.shared.runningApplications.filter { $0.bundleIdentifier == mainAppBundleID }
        
        if runningApps.isEmpty {
            if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainAppBundleID) {
                let configuration = NSWorkspace.OpenConfiguration()
                configuration.activates = false
                NSWorkspace.shared.openApplication(at: appURL, configuration: configuration) { app, error in
                    if let error = error {
                        print("Error launching main app: \(error)")
                    }
                    NSApp.terminate(nil)
                }
            } else {
                print("Main app URL not found for bundle ID: \(mainAppBundleID)")
                NSApp.terminate(nil)
            }
        } else {
            NSApp.terminate(nil)
        }
    }
}
