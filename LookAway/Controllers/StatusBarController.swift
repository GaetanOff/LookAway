import Cocoa
import Combine
import SwiftUI

class StatusBarController: NSObject, NSWindowDelegate {
    private var statusItem: NSStatusItem
    private var timerManager: TimerManager
    private var cancellable: AnyCancellable?
    private var settingsCancellable: AnyCancellable?
    private var cancelPauseItem: NSMenuItem?
    
    private var preferencesWindowController: PreferencesWindowController?
    
    init(timerManager: TimerManager) {
        self.timerManager = timerManager
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()
        
        if let button = statusItem.button {
            button.title = "\(timerManager.remainingSeconds / 60)m" + SettingsManager.shared.statusSuffix
        }
        constructMenu()
        
        cancellable = timerManager.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateStatusBar()
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
            button.title = (timerManager.isPaused ? "Pause" : "\(timerManager.remainingSeconds / 60)m") + SettingsManager.shared.statusSuffix
        }
        cancelPauseItem?.isHidden = !timerManager.isPaused
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
        
        let pause30 = NSMenuItem(title: "Pause 30 minutes", action: #selector(pause30Action), keyEquivalent: "3")
        pause30.target = self
        menu.addItem(pause30)
        
        let pause60 = NSMenuItem(title: "Pause 1 hour", action: #selector(pause60Action), keyEquivalent: "1")
        pause60.target = self
        menu.addItem(pause60)
        
        let pause120 = NSMenuItem(title: "Pause 2 hours", action: #selector(pause120Action), keyEquivalent: "2")
        pause120.target = self
        menu.addItem(pause120)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
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
