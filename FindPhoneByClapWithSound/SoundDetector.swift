//
//  SoundDetector.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 19/08/25.
//

import SwiftUI
import AVFoundation

class SoundDetector: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var player: AVAudioPlayer?

    func startListening() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.analyzeBuffer(buffer: buffer)
        }

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

        // Simple threshold detection
        if avgPower > -10 { // adjust threshold based on testing
            DispatchQueue.main.async {
                self.playAlarm()
            }
        }
    }

    private func playAlarm() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
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
