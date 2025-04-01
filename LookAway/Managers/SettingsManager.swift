import Foundation
import Combine

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var breakDuration: Int {
        didSet {
            UserDefaults.standard.set(breakDuration, forKey: "breakDuration")
        }
    }
    @Published var breakEvery: Int {
        didSet {
            UserDefaults.standard.set(breakEvery, forKey: "breakEvery")
        }
    }
    @Published var overlayTitle: String {
        didSet {
            UserDefaults.standard.set(overlayTitle, forKey: "overlayTitle")
        }
    }
    @Published var overlayDescription: String {
        didSet {
            UserDefaults.standard.set(overlayDescription, forKey: "overlayDescription")
        }
    }
    @Published var statusSuffix: String {
        didSet {
            UserDefaults.standard.set(statusSuffix, forKey: "statusSuffix")
        }
    }
    @Published var resetTimerOnSleep: Bool {
        didSet {
            UserDefaults.standard.set(resetTimerOnSleep, forKey: "resetTimerOnSleep")
        }
    }

    
    private init() {
        let defaults = UserDefaults.standard
        
        let savedBreakDuration = defaults.integer(forKey: "breakDuration")
        breakDuration = savedBreakDuration == 0 ? 20 : savedBreakDuration
        
        let savedBreakEvery = defaults.integer(forKey: "breakEvery")
        breakEvery = savedBreakEvery == 0 ? 20 : savedBreakEvery
        
        overlayTitle = defaults.string(forKey: "overlayTitle") ?? "Relax those eyes"
        overlayDescription = defaults.string(forKey: "overlayDescription") ?? "Choose a distant view to set your sight on until the timer ends"
        statusSuffix = defaults.string(forKey: "statusSuffix") ?? " | Eyes"
        resetTimerOnSleep = defaults.bool(forKey: "resetTimerOnSleep")
    }
    
    func resetToDefaults() {
        breakDuration = 20
        breakEvery = 20
        overlayTitle = "Relax those eyes"
        overlayDescription = "Choose a distant view to set your sight on until the timer ends"
        statusSuffix = " | Eyes"
        resetTimerOnSleep = false
    }
}
