import SwiftUI

struct OverlayView: View {
    let breakDuration: Int
    let completion: () -> Void
    
    @State private var secondsRemaining: Int = 0
    @State private var countdownTimer: Timer?
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.95
    @ObservedObject var settings = SettingsManager.shared
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .opacity(opacity)
            
            RadialGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.black.opacity(0)]),
                center: .center,
                startRadius: 150,
                endRadius: 500
            )
            .ignoresSafeArea()
            .opacity(opacity)
            
            VStack(spacing: 20) {
                Text(settings.overlayTitle)
                    .font(.system(size: 38, weight: .medium))
                    .foregroundColor(.white)
                
                Text(settings.overlayDescription)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, -5)
                
                Divider()
                    .background(Color.white.opacity(0.3))
                    .frame(width: 150)
                    .padding(.vertical, 15)
                
                Text(formattedTime(secondsRemaining))
                    .font(.system(size: 38, weight: .regular))
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
            .padding()
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1.0
                scale = 1.0
            }
            startCountdown()
        }
    }
    
    private func startCountdown() {
        secondsRemaining = breakDuration
        countdownTimer?.invalidate()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if secondsRemaining > 1 {
                secondsRemaining -= 1
            } else {
                endBreak()
            }
        }
    }
    
    private func endBreak() {
        countdownTimer?.invalidate()
        
        // Animation de disparition douce
        withAnimation(.easeIn(duration: 0.6)) {
            opacity = 0
            scale = 1.05
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            OverlayWindowController.shared.hideOverlay()
            completion()
        }
    }
    
    private func formattedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
