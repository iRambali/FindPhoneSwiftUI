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
    
    
    private var audioEngine = AVAudioEngine()
    private var player: AVAudioPlayer?
    private var torchOn = false
    @Published var mode: ActionMode = .alarm
    @Published var isListening = false

    func startListening() {
        if isListening { return }
        isListening = true
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
        isListening = false
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
                    self.sosFlashlight()
                }
            }
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
        torchBlink(on: 2.0, off: 2.0, repeat: 5)
    }
    
    // 🔥 Firelight: Random flickering (simulate fire)
    func firelight() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        DispatchQueue.global().async {
            for _ in 0..<20 {
                let level = Float.random(in: 0.2...1.0) // random brightness
                let duration = TimeInterval.random(in: 0.05...0.3)
                do {
                    try device.lockForConfiguration()
                    try device.setTorchModeOn(level: level)
                    device.unlockForConfiguration()
                    Thread.sleep(forTimeInterval: duration)
                } catch {}
            }
            // turn OFF
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {}
        }
    }
    
    // ⚡ Flicker: Fast irregular blinks
    func flicker() {
        for _ in 0..<10 {
            let on = TimeInterval.random(in: 0.05...0.15)
            let off = TimeInterval.random(in: 0.05...0.2)
            torchBlink(on: on, off: off)
        }
    }
    
    // 💡 Standard: Steady ON
    func standard() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        DispatchQueue.global().async {
            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 1.0)
                device.unlockForConfiguration()
            } catch {}
        }
    }
    
    // 🟢 Green Light: (⚠️ iPhone torch is white LED → can’t change color without screen trick)
    // So we fake "green light" by blinking in a fixed pattern
    func greenLight() {
        torchBlink(on: 1.0, off: 0.5, repeat: 3)
    }
    
    // 🚨 Strobe: Very fast blinking
    func strobe() {
        torchBlink(on: 0.1, off: 0.1, repeat: 20)
    }
    
    // 🎉 Party: Random ON/OFF durations like disco
    func party() {
        for _ in 0..<15 {
            let on = TimeInterval.random(in: 0.1...0.5)
            let off = TimeInterval.random(in: 0.1...0.5)
            torchBlink(on: on, off: off)
        }
    }
    
    // 🌙 Dim Light: Soft low brightness (iOS torch supports levels)
    func dim() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        DispatchQueue.global().async {
            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 0.2) // dim at 20%
                device.unlockForConfiguration()
            } catch {}
        }
    }
}
