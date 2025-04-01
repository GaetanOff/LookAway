import SwiftUI

struct PreferencesView: View {
    @ObservedObject var settings = SettingsManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Text("Break Settings")
                    .font(.headline)
            }
            .padding(.bottom, 5)
            
            HStack {
                Text("Break Every:")
                    .frame(width: 120, alignment: .leading)
                Spacer()
                Text("\(settings.breakEvery) minutes")
                    .frame(width: 120, alignment: .trailing)
                Stepper("", value: $settings.breakEvery, in: 5...300, step: 5)
                    .labelsHidden()
            }
            
            HStack {
                Text("Break Duration:")
                    .frame(width: 120, alignment: .leading)
                Spacer()
                Text("\(settings.breakDuration) seconds")
                    .frame(width: 120, alignment: .trailing)
                Stepper("", value: $settings.breakDuration, in: 5...300, step: 5)
                    .labelsHidden()
            }
            
            HStack {
                Spacer()
                Text("Overlay Text")
                    .font(.headline)
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            HStack {
                Text("Title:")
                    .frame(width: 120, alignment: .trailing)
                TextField("Relax those eyes", text: $settings.overlayTitle)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 24)
                    .padding(4)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(4)
            }
            
            HStack {
                Text("Description:")
                    .frame(width: 120, alignment: .trailing)
                TextField("Choose a distant view to set your sight on until the timer ends", text: $settings.overlayDescription)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 24)
                    .padding(4)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(4)
            }
            
            HStack {
                Spacer()
                Text("Status Bar")
                    .font(.headline)
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            HStack {
                Text("Status Bar Suffix:")
                    .frame(width: 120, alignment: .trailing)
                Text("min")
                    .foregroundColor(.secondary)
                TextField("| Eyes", text: $settings.statusSuffix)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(width: 100, height: 24)
                    .padding(4)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(4)
            }
            
            Section() {
                Toggle("Reset Timer on Sleep/Lock", isOn: $settings.resetTimerOnSleep)
                    .onChange(of: settings.resetTimerOnSleep) { newValue, _ in
                    }
            }

            
            Spacer()
            
            HStack {
                Spacer()
                Button("Reset to Defaults") {
                    settings.resetToDefaults()
                }
                .padding(.horizontal)
                
                Button("Save") {
                    NSApp.keyWindow?.close()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 10)
        }
        .padding()
        .frame(width: 500, height: 480)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
