# **LookAway** 🚀  
🛠️ **A macOS menu-bar application to protect your eyes by prompting regular breaks.**

---

## **📌 Features**
✅ **Menu Bar Only**: No Dock icon – the app lives entirely in your status bar.
✅ **Configurable Breaks**: Set the frequency and duration of your eye breaks.
✅ **Customizable Overlay**: Change the title and description text shown during break time.
✅ **Pause and Resume**: Easily pause or cancel a break when needed.
✅ **Launch at Login**: Optionally start LookAway automatically when you log in.

---

## **📦 Installation**
### **1️⃣ Download the last version of the app [here](https://github.com/GaetanOff/LookAway/releases)**

### **2️⃣ Unzip & Move it to your Applications Folder**

### **3️⃣ Add it to your [startup items](https://www.lifewire.com/how-to-add-startup-items-to-mac-2260903) so that it launches automatically on startup**

---

## **⚙️ How It Works**
- **Timer Management:** The app counts down based on your configured "Break Every" interval. When the timer reaches zero, an overlay appears prompting you to take a break.
- **Preferences:** Using the preferences panel, you can customize:
  - The interval between breaks (in minutes)
  - The duration of the break overlay (in seconds)
  - The overlay’s title and description
  - The status bar suffix

---

## **📂 Project Structure**
```
LookAway/
│── LookAway/                           # Main application
│    ├── AppDelegate.swift
│    ├── LookAwayApp.swift              # Entry point (menu-bar only)
│    ├── Controllers
│    │    ├── OverlayWindowController.swift
│    │    ├── PreferencesWindowController.swift
│    │    └── StatusBarController.swift
│    ├── Managers
│    │    ├── SettingsManager.swift      # Configurable settings (e.g., break duration, interval)
│    │    └── TimerManager.swift         # Handles countdown and triggering breaks
│    ├── Resources
│    │    └── Assets.xcassets
│    ├── Views
│    │    ├── OverlayView.swift          # Break overlay UI
│    │    └── PreferencesView.swift      # Preferences UI
│    ├── LookAway.entitlements
│    └── Info.plist
│── LookAway.xcodeproj                   # Xcode project file
│── LookAwayTests/                       # Unit tests
│── LookAwayUITests/                     # UI tests
└── README.md                            # Project documentation
```

---

## **📝 Customization**
You can easily update the look and behavior of LookAway:
- **Preferences:** Use the Preferences panel (accessible from the status bar menu) to change break intervals, durations, overlay texts, and more.
- **SettingsManager:** Modify default values or add new settings in `SettingsManager.swift`.
- **UI Updates:** Customize the overlay UI in `OverlayView.swift` or the preferences UI in `PreferencesView.swift` using SwiftUI.

---

## **📝 License**
This project is licensed under the [GPL v3](https://www.gnu.org/licenses/gpl-3.0.en.html).  
Feel free to modify and improve the code!

---

## **🙌 Contributing**
💡 **Got ideas, suggestions, or bug reports?**  
Please open an **issue** or submit a **pull request** on GitHub!

---

## **📬 Contact**
📧 **contact@gaetandev.fr**  
🌍 **[Website](https://gaetandev.fr)**  
💬 **Discord: GaetanDev**

---

## **🎉 Thank You for Using LookAway!**
If you have any questions or suggestions, don't hesitate to contact me!


--- 

<img src="https://cdn.gaetandev.fr/lookaway/Break.png" />
<img src="https://cdn.gaetandev.fr/lookaway/StatusBar.png" />
<img src="https://cdn.gaetandev.fr/lookaway/Settings.png" />
