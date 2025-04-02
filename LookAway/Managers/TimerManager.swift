import Foundation
import Combine
import Cocoa

class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var remainingSeconds: Int = 20 * 60
    @Published var isPaused: Bool = false
    @Published var breakActive: Bool = false
    @Published var pauseRemainingSeconds: Int? = nil
    
    private var timer: Timer?
    private var pauseTimer: Timer?
    private var pauseWorkItem: DispatchWorkItem?
    private var currentPauseDuration: Int?
    
    var currentPause: Int? {
        return currentPauseDuration
    }
    
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
        if isPaused, let current = pauseRemainingSeconds {
            remainingSeconds -= current
        }
        isPaused = true
        currentPauseDuration = seconds
        remainingSeconds += seconds
        pauseRemainingSeconds = seconds

        pauseTimer?.invalidate()
        pauseTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let current = self.pauseRemainingSeconds else { return }
            if current > 1 {
                self.pauseRemainingSeconds = current - 1
            } else {
                self.pauseTimer?.invalidate()
                self.pauseTimer = nil
                self.isPaused = false
                self.pauseRemainingSeconds = nil
                self.currentPauseDuration = nil
            }
        }
    }
    
    func cancelPause() {
        if isPaused {
            if let pauseDuration = currentPauseDuration {
                if remainingSeconds > pauseDuration {
                    remainingSeconds -= pauseDuration
                }
            }
        }
        
        pauseTimer?.invalidate()
        pauseTimer = nil
        pauseRemainingSeconds = nil
        currentPauseDuration = nil
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
