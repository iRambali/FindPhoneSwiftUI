//
//  SoundDetectionView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 19/08/25.
//

import SwiftUI

struct SoundDetectionView: View {
    
    let icons = [
        ("coughing", "coughing"),
        ("snapping", "snapping"),
        ("sneezing", "sneezing"),
        ("train", "train"),
        ("hello", "hello"),
        ("air-horn", "air_horn"),
        ("shouting", "shouting"),
        ("singing", "singing"),
        ("say-name", "say_name"),
        ("clap", "clap"),
        ("whistle", "whistle"),
        ("laughing", "laughing")
    ]

    @Environment(\.dismiss) var dismiss
    @State private var isTapped = false
    @StateObject private var detector = SoundDetector()
    
    var body: some View {
        
        VStack() {
            
            HStack {
                
                Button(action: {
                    print("back button tapped.")
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                Text("Sound Detection")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding()
            .padding(.leading)
            
            //detected sound
            VStack {
                SoundAnimationView()
            }
            .padding(.top, 50)
            
            
            VStack {
                Text("Snapping")
                    .font(Font.system(size: 24, weight: .bold))
                    .foregroundColor(Color.white)
            }
            .padding(.top, 50)
            
            
            VStack {
                Button(action: {
                    print("Button tapped!")
                    isTapped.toggle()
            //      isTapped ? detector.startListening() : detector.stopListening()
                }) {
                    ZStack {
                        if isTapped {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.colorActiveDetectionBtn)
                                .frame(width: 320, height: 60)
                        } else {
                            Capsule()
                                .fill(Color.colorSoundDetectionBtn)
                                .overlay(
                                    Capsule().stroke(Color.green, lineWidth: 2)
                                )
                                .shadow(radius: 2)
                                .frame(width: 320, height: 60)
                        }
                        
                        Text("Activate Clap detection")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }

            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 20) {
                        ForEach(icons, id: \.1) { icon in
                            VStack {
                                IconTabVeiw(imageName: icon.0, title: LanguageManager.shared.localizedString(for: icon.1))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 50)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // hides system back button
        .background(Color.colorBackground)
        
    }
        
}

#Preview {
    SoundDetectionView()
}
