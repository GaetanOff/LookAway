import Cocoa
import SwiftUI

class OverlayWindowController {
    static let shared = OverlayWindowController()
    
    private var window: NSWindow?
    
    func showOverlay(completion: @escaping () -> Void) {
        let screenFrame = NSScreen.main?.frame ?? .zero
        let hostingView = NSHostingView(rootView: OverlayView(breakDuration: SettingsManager.shared.breakDuration, completion: completion))
        
        window = NSWindow(contentRect: screenFrame,
                          styleMask: [.borderless],
                          backing: .buffered,
                          defer: false)
        window?.level = .mainMenu + 1
        window?.isOpaque = false
        window?.backgroundColor = NSColor.black.withAlphaComponent(0.7)
        window?.contentView = hostingView
        window?.makeKeyAndOrderFront(nil)
    }
    
    func hideOverlay() {
        window?.orderOut(nil)
        window = nil
    }
}
