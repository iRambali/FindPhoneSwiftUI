//
//  SoundDetector.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 19/08/25.
//

import SwiftUI
import AVFoundation

class SoundDetector: ObservableObject {
    
    enum ActionMode {
        case alarm
        case flashlight
    }
    
    
    private var audioEngine = AVAudioEngine()
    private var player: AVAudioPlayer?
    private var torchOn = false
    @Published var mode: ActionMode = .alarm

    func startListening() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        //        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
        //            self.analyzeBuffer(buffer: buffer)
        //        }
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
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
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

        print("Sound average power: \(avgPower) dB")
        // Simple threshold detection
//        if avgPower > -30 { // adjust threshold based on testing
//            DispatchQueue.main.async {
//                self.playAlarm()
//                self.toggleFlashlight(on: true)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//                    self.toggleFlashlight(on: false)
//                }
//            }
//        }
        
        
        
        
        if avgPower > -30 { // threshold
            self.stopListening()
            DispatchQueue.main.async {
                switch self.mode {
                case .alarm:
                    self.playAlarm()
                case .flashlight:
                    self.blinkFlashlight()
                }
            }
        }
    }
    
//    /// 🔦 Flashlight control
//       private func toggleFlashlight(on: Bool) {
//           guard let device = AVCaptureDevice.default(for: .video),
//                 device.hasTorch else {
//               print("⚠️ Torch not available")
//               return
//           }
//           
//           do {
//               try device.lockForConfiguration()
//               device.torchMode = on ? .on : .off
//               try device.setTorchModeOn(level: 1.0) // full brightness
//               device.unlockForConfiguration()
//               print(on ? "🔦 Flashlight ON" : "🔦 Flashlight OFF")
//           } catch {
//               print("❌ Flashlight error: \(error.localizedDescription)")
//           }
//       }
    
    
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
