import Foundation
import Combine
import Cocoa

class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var remainingSeconds: Int = 20 * 60
    @Published var isPaused: Bool = false
    @Published var breakActive: Bool = false
    
    private var timer: Timer?
    private var pauseWorkItem: DispatchWorkItem?
    private var currentPauseDuration: Int?
    
    private var settingsCancellable: AnyCancellable?
    
    private init() {
        remainingSeconds = SettingsManager.shared.breakEvery * 60
        startTimer()
        
        settingsCancellable = SettingsManager.shared.$breakEvery.sink { [weak self] newValue in
            guard let self = self, !self.breakActive, !self.isPaused else { return }
            self.remainingSeconds = newValue * 60
        }
        
        let workspaceNC = NSWorkspace.shared.notificationCenter
        workspaceNC.addObserver(self, selector: #selector(handleSleepOrLock), name: NSWorkspace.willSleepNotification, object: nil)
        workspaceNC.addObserver(self, selector: #selector(handleSleepOrLock), name: NSWorkspace.sessionDidResignActiveNotification, object: nil)
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    private func timerTick() {
        guard !isPaused else { return }
        if remainingSeconds > 0 {
            remainingSeconds -= 1
        } else {
            triggerBreak()
        }
    }
    
    private func triggerBreak() {
        guard !breakActive else { return }
        breakActive = true
        OverlayWindowController.shared.showOverlay {
            self.resetTimer()
        }
    }
    
    func resetTimer() {
        remainingSeconds = SettingsManager.shared.breakEvery * 60
        breakActive = false
    }
    
    func pause(for seconds: Int) {
        guard !isPaused else { return }
        isPaused = true
        currentPauseDuration = seconds
        remainingSeconds += seconds
        
        let workItem = DispatchWorkItem {
            self.isPaused = false
            self.pauseWorkItem = nil
            self.currentPauseDuration = nil
        }
        pauseWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: workItem)
    }
    
    func cancelPause() {
        if let pauseDuration = currentPauseDuration {
            remainingSeconds -= pauseDuration
            currentPauseDuration = nil
        }
        pauseWorkItem?.cancel()
        pauseWorkItem = nil
        isPaused = false
    }
    
    func forceBreak() {
        guard !breakActive else { return }
        breakActive = true
        OverlayWindowController.shared.showOverlay {
            self.resetTimer()
        }
    }
    
    @objc private func handleSleepOrLock() {
        if SettingsManager.shared.resetTimerOnSleep {
            resetTimer()
        }
    }
}
