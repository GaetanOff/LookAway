import Cocoa
import Combine
import SwiftUI

class StatusBarController: NSObject, NSWindowDelegate {
    private var statusItem: NSStatusItem
    private var timerManager: TimerManager
    private var cancellable: AnyCancellable?
    private var settingsCancellable: AnyCancellable?
    private var cancelPauseItem: NSMenuItem?
    
    private var pause30: NSMenuItem?
    private var pause60: NSMenuItem?
    private var pause120: NSMenuItem?
    
    private var preferencesWindowController: PreferencesWindowController?
    
    init(timerManager: TimerManager) {
        self.timerManager = timerManager
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()
        
        updateStatusBar()
        constructMenu()
        
        cancellable = timerManager.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateStatusBar()
                self?.updateMenuItems()
            }
        }
        settingsCancellable = SettingsManager.shared.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateStatusBar()
            }
        }
    }
    
    private func updateStatusBar() {
        if let button = statusItem.button {
            let title = timerManager.isPaused ? "Pause" : "\((timerManager.remainingSeconds + 59) / 60)m"
            button.title = title + SettingsManager.shared.statusSuffix
        }
        cancelPauseItem?.isHidden = !timerManager.isPaused
    }
    
    private func updateMenuItems() {
        pause30?.title = menuTitle(base: "Pause 30 minutes", duration: 30 * 60)
        pause60?.title = menuTitle(base: "Pause 1 hour", duration: 60 * 60)
        pause120?.title = menuTitle(base: "Pause 2 hours", duration: 120 * 60)
    }
    
    private func menuTitle(base: String, duration: Int) -> String {
        if timerManager.isPaused, let remaining = timerManager.pauseRemainingSeconds, timerManager.currentPause == duration {
            return "\(base) (\(formattedTime(remaining)) left)"
        } else {
            return base
        }
    }
    
    private func formattedTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func constructMenu() {
        let menu = NSMenu()
        
        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(showPreferences), keyEquivalent: ",")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        let breakItem = NSMenuItem(title: "Take a Break", action: #selector(takeABreakAction), keyEquivalent: "t")
        breakItem.target = self
        menu.addItem(breakItem)
        
        let cancelPause = NSMenuItem(title: "Cancel pause", action: #selector(cancelPauseAction), keyEquivalent: "c")
        cancelPause.target = self
        cancelPauseItem = cancelPause
        menu.addItem(cancelPause)
        
        menu.addItem(NSMenuItem.separator())
        
        pause30 = NSMenuItem(title: "Pause 30 minutes", action: #selector(pause30Action), keyEquivalent: "3")
        pause30?.target = self
        menu.addItem(pause30!)
        
        pause60 = NSMenuItem(title: "Pause 1 hour", action: #selector(pause60Action), keyEquivalent: "1")
        pause60?.target = self
        menu.addItem(pause60!)
        
        pause120 = NSMenuItem(title: "Pause 2 hours", action: #selector(pause120Action), keyEquivalent: "2")
        pause120?.target = self
        menu.addItem(pause120!)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
        updateMenuItems()
        cancelPauseItem?.isHidden = !timerManager.isPaused
    }
    
    @objc func showPreferences() {
        if let controller = preferencesWindowController {
            controller.window?.makeKeyAndOrderFront(nil)
        } else {
            let controller = PreferencesWindowController()
            preferencesWindowController = controller
            controller.showWindow(nil)
        }
    }
    
    @objc func takeABreakAction() {
        timerManager.forceBreak()
    }
    
    @objc func cancelPauseAction() {
        timerManager.cancelPause()
    }
    
    @objc func pause30Action() {
        timerManager.pause(for: 30 * 60)
    }
    
    @objc func pause60Action() {
        timerManager.pause(for: 60 * 60)
    }
    
    @objc func pause120Action() {
        timerManager.pause(for: 120 * 60)
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}
