//
//  SoundDetector.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 19/08/25.
//

import SwiftUI
import AVFoundation

class SoundDetector: ObservableObject {
    
    static let shared = SoundDetector()
    enum ActionMode {
        case alarm
        case flashlight
    }
    
    enum FlashlightMode {
        case standard
        case lighthouse
        case fireLight
        case flicker
        case greenLight
        case strobe
        case sos
        case party
        case dim
    }
    
    
    private var audioEngine = AVAudioEngine()
    private var player: AVAudioPlayer?
    @Published var mode: ActionMode = .alarm
    @Published var isListening = false
    @Published var flashlightMode: FlashlightMode = .standard
    
    
    private var torchQueue = DispatchQueue(label: "torchQueue", qos: .userInitiated)
        private var currentTorchWorkItem: DispatchWorkItem?
        var isTorchActive = false
        var shouldStopTorch = false

    func startListening() {
        if isListening { return }
        DispatchQueue.main.async {
            self.isListening = true
        }
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
#if targetEnvironment(simulator)
        print("🎛️ Audio detection is not supported in Simulator.")
#else
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.analyzeBuffer(buffer: buffer)
        }
#endif
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            print("🎙️ Listening started")
        } catch {
            print("❌ Could not start audio engine: \(error.localizedDescription)")
        }
    }

    func stopListening() {
        if !isListening { return }
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        DispatchQueue.main.async {
            self.isListening = false
        }
        
        print("🛑 Listening stopped")
    }

    private func analyzeBuffer(buffer: AVAudioPCMBuffer) {
        // Get average power level
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let channelDataValue = stride(from: 0,
                                      to: Int(buffer.frameLength),
                                      by: buffer.stride).map { channelData[$0] }

        let rms = sqrt(channelDataValue.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
        let avgPower = 20 * log10(rms)

//        print("Sound average power: \(avgPower) dB")
        if avgPower > -30 { // threshold
            self.stopListening()
            DispatchQueue.main.async {
                switch self.mode {
                case .alarm:
                    self.playAlarm()
                case .flashlight:
//                    self.blinkFlashlight()
                    self.activateFlashlight(mode: self.flashlightMode)
                }
            }
        }
    }
    
    func activateFlashlight(mode: FlashlightMode) {
        print("Activating flashlight mode: \(mode)")
        switch mode {
        case .standard:
            standard()
        case .lighthouse:
            lighthouse()
        case .fireLight:
            firelight()
        case .flicker:
            flicker()
        case .greenLight:
            greenLight()
        case .strobe:
            strobe()
        case .sos:
            sosFlashlightLoopIndefinitely()
        case .party:
            party()
        case .dim:
            dim()
        }
    }

    /// 🔦 Blink flashlight like an alarm
        private func blinkFlashlight() {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else {
                print("⚠️ Torch not available")
                return
            }
            
            DispatchQueue.global().async {
                for _ in 0..<5 { // blink 5 times
                    do {
                        try device.lockForConfiguration()
                        try device.setTorchModeOn(level: 1.0)
                        device.unlockForConfiguration()
                        usleep(300_000) // ON 0.3s
                        
                        try device.lockForConfiguration()
                        device.torchMode = .off
                        device.unlockForConfiguration()
                        usleep(300_000) // OFF 0.3s
                    } catch {
                        print("❌ Torch error: \(error.localizedDescription)")
                    }
                }
            }
        }
    
    
    func sosFlashlightLoopIndefinitely() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            print("⚠️ Torch not available")
            return
        }

        // Stop any existing torch effect
        stopTorchEffect()

        let dot: TimeInterval = 0.1   // short blink
        let dash: TimeInterval = 0.2  // long blink
        let gap: TimeInterval = 0.1   // gap between blinks
        let pattern: [TimeInterval] = [dot, dot, dot, dash, dash, dash, dot, dot, dot]

        shouldStopTorch = false
        isTorchActive = true

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            while !self.shouldStopTorch {
                for duration in pattern {
                    if self.shouldStopTorch { break }
                    do {
                        try device.lockForConfiguration()
                        try device.setTorchModeOn(level: 1.0)
                        device.unlockForConfiguration()
                        Thread.sleep(forTimeInterval: duration) // ON

                        try device.lockForConfiguration()
                        device.torchMode = .off
                        device.unlockForConfiguration()
                        Thread.sleep(forTimeInterval: gap) // OFF
                    } catch {
                        print("❌ Torch error: \(error.localizedDescription)")
                    }
                }
                // Pause between SOS cycles
                Thread.sleep(forTimeInterval: 0.4)
            }
            self.isTorchActive = false
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }


    
    func sosFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            print("⚠️ Torch not available")
            return
        }
        
        let dot: TimeInterval = 0.2   // short blink
        let dash: TimeInterval = 0.6  // long blink
        let gap: TimeInterval = 0.2   // gap between blinks

        DispatchQueue.global().async {
            // SOS pattern = ... --- ...
            let pattern: [TimeInterval] = [dot, dot, dot, dash, dash, dash, dot, dot, dot]
            
            for duration in pattern {
                do {
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: 1.0)
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: duration) // ON duration
                    
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: gap) // OFF gap
                } catch {
                    print("❌ Torch error: \(error.localizedDescription)")
                }
            }
        }
    }


    
    func stopAlarm() {
        player?.stop()
        player = nil
        print("🔇 Alarm stopped")
    }
    
    
    func stopTorchEffect() {
        shouldStopTorch = true
        currentTorchWorkItem?.cancel()
        currentTorchWorkItem = nil

        // Ensure torch is OFF
        if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                print("❌ Torch stop error: \(error.localizedDescription)")
            }
        }
        isTorchActive = false
    }

    
    
    private func playAlarm() {
        guard let url = Bundle.main.url(forResource: "findphonesound", withExtension: "mp3") else {
            print("Alarm sound file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("🚨 Alarm playing")
        } catch {
            print("❌ Could not play alarm: \(error.localizedDescription)")
        }
    }
}


extension SoundDetector {
    
    /// Common helper: turn torch ON for `duration`, then OFF for `gap`
    private func torchBlink(on duration: TimeInterval, off gap: TimeInterval, repeat count: Int = 1) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        DispatchQueue.global().async {
            for _ in 0..<count {
                do {
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: 1.0)
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: duration)
                    
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: gap)
                } catch {
                    print("❌ Torch error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 🌊 Lighthouse: Long sweep-like blink (on 2s, off 2s)
    func lighthouse() {
        stopTorchEffect()
        shouldStopTorch = false

        let workItem = DispatchWorkItem {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }

            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 1.0) // full brightness ON
                device.unlockForConfiguration()
                print("🔦 Lighthouse ON")
            } catch {
                print("❌ Torch error: \(error.localizedDescription)")
            }

            // Keep it ON until stopped
            while !self.shouldStopTorch {
                Thread.sleep(forTimeInterval: 0.5)
            }

            // Turn OFF when stopped
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
                print("🔦 Lighthouse OFF")
            } catch {}
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }


    
    // 🔥 Firelight: Random flickering (simulate fire)
    func firelight() {
        stopTorchEffect()
        shouldStopTorch = false

        let workItem = DispatchWorkItem {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }

            while !self.shouldStopTorch {
                do {
                    // ✅ ON phase
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: 0.8) // Full brightness
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: 0.2) // ON duration

                    // ✅ OFF phase
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: 0.1) // OFF duration

                } catch {
                    print("❌ Torch error: \(error.localizedDescription)")
                }
            }

            // Make sure torch OFF when stopped
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    print("🟢 Green light stopped, torch OFF")
                } catch {}
            }
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }

    
    // ⚡ Flicker: Fast irregular blinks
    // ✨ Flicker: Fast random short ON/OFF like a candle flicker
    func flicker() {
        stopTorchEffect()
        shouldStopTorch = false

        let workItem = DispatchWorkItem {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }

            while !self.shouldStopTorch {
                let on = TimeInterval.random(in: 0.05...0.15)
                let off = TimeInterval.random(in: 0.05...0.2)

                do {
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: 1.0)
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: on)

                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: off)
                } catch {
                    print("❌ Torch error: \(error.localizedDescription)")
                }
            }

            // ✅ Ensure torch OFF when stopped
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {}
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }

    
    // 💡 Standard: Steady ON (runs indefinitely until stopped)
    func standard() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        // Stop any previous effect first
        stopTorchEffect()
        
        shouldStopTorch = false
        isTorchActive = true
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 1.0) // steady ON
                device.unlockForConfiguration()
            } catch {
                print("❌ Torch error: \(error.localizedDescription)")
            }
            // nothing more, torch will stay ON until stopTorchEffect() is called
        }
        
        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }

    
    
    
    // 🟢 Green Light: (⚠️ iPhone torch is white LED → can’t change color without screen trick)
    // So we fake "green light" by blinking in a fixed pattern
    func greenLight() {
        stopTorchEffect()
        shouldStopTorch = false

        let workItem = DispatchWorkItem {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }

            while !self.shouldStopTorch {
                do {
                    // ✅ ON phase
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: 1.0) // Full brightness
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: 0.2) // ON duration

                    // ✅ OFF phase
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: 0.1) // OFF duration

                } catch {
                    print("❌ Torch error: \(error.localizedDescription)")
                }
            }

            // Make sure torch OFF when stopped
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    print("🟢 Green light stopped, torch OFF")
                } catch {}
            }
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }

    
    // 🚨 Strobe: Very fast blinking
    func strobe() {
        stopTorchEffect()
        shouldStopTorch = false

        let workItem = DispatchWorkItem {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }

            while !self.shouldStopTorch {
                do {
                    // ✅ ON (very short flash)
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: 1.0)
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: 0.05)

                    // ✅ OFF (very short gap)
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: 0.05)

                } catch {
                    print("❌ Torch error: \(error.localizedDescription)")
                }
            }

            // ✅ Ensure torch turns OFF when stopped
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    print("⚡ Strobe stopped, torch OFF")
                } catch {}
            }
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }

    
    // 🎉 Party: Random ON/OFF durations like disco
    func party() {
        stopTorchEffect()
        shouldStopTorch = false

        let workItem = DispatchWorkItem {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }

            while !self.shouldStopTorch {
                let on = TimeInterval.random(in: 0.1...0.3)
                let off = TimeInterval.random(in: 0.05...0.2)

                do {
                    // ✅ ON
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: 1.0)
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: on)

                    // ✅ OFF
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: off)
                } catch {
                    print("❌ Torch error: \(error.localizedDescription)")
                }
            }

            // ✅ Ensure torch turns OFF when stopped
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    print("🎉 Party mode stopped, torch OFF")
                } catch {}
            }
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }

    
    // 🌙 Dim Light: Soft low brightness (iOS torch supports levels)
    // 💡 Dim Light: Steady ON at low brightness
    func dim() {
        stopTorchEffect()
        shouldStopTorch = false

        let workItem = DispatchWorkItem {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }

            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 0.5) // ✅ steady at 50%
                device.unlockForConfiguration()
                print("💡 Dim light ON at 20% brightness")

                // 🔄 Keep running until stopped
                while !self.shouldStopTorch {
                    Thread.sleep(forTimeInterval: 0.5)
                }

                // ✅ Turn OFF when stopped
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
                print("💡 Dim light stopped, torch OFF")

            } catch {
                print("❌ Torch error: \(error.localizedDescription)")
            }
        }

        currentTorchWorkItem = workItem
        torchQueue.async(execute: workItem)
    }

}
