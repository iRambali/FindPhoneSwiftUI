//
//  SoundDetectionView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 19/08/25.
//

import SwiftUI

struct SoundDetectionView: View {

    @Environment(\.dismiss) var dismiss
    @State private var isTapped = false
    @ObservedObject private var detector = SoundDetector.shared
    
    
    var tabIcons:[(String, String, String)]
    @State var selectedIcon: (String, String, String)
    
    var body: some View {
        
        VStack() {
            //MARK: Navigation Header
            HStack {
                Button(action: {
                    dismiss()
                    detector.stopListening()
                    detector.stopAlarm()
                    detector.stopTorchEffect()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.App.buttonTitle)
                        .foregroundColor(Color.colorText)
                }
                
                Spacer()
                
                Text(LanguageManager.shared.localizedString(for: detector.mode == .alarm ? "sound_detection" : "selected_flash_light"))
                    .font(.App.navigationTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.colorText)
                Spacer()
            }
            .padding()
            .padding(.leading)
            
            //detected sound
            VStack {
                SoundAnimationView(iconImage: selectedIcon.0)
            }
            .padding(.top, 40)
            
            
            VStack {
                Text(LanguageManager.shared.localizedString(for: selectedIcon.1))
                    .font(.App.heading)
                    .foregroundColor(Color.colorText)
               
            }
            .onAppear {
                detector.setFlashlightMode(for: selectedIcon.1)
            }
            .padding(.top, 50)
            
            
            VStack {
                Button(action: {
                    print("Button tapped!")
                    isTapped.toggle()
                    
                    if isTapped {
                        detector.startListening(soundName: selectedIcon.2)
                        print("Sound name : \(selectedIcon.2)")
                    }else {
                        detector.stopListening()
                        detector.stopAlarm()
                        detector.stopTorchEffect()
                    }
                    
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
                        let btnLabel = detector.mode == .flashlight
                            ? (isTapped ? "deactivate_flashlight" : "activate_flashlight")
                            : (isTapped ? "stop_clap_detection" : "activate_clap_detection")
                        Text(LanguageManager.shared.localizedString(for: btnLabel))
                            .font(.App.buttonTitle)
                            .foregroundColor(.white)
                    }
                }
            }

            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 20) {
                        ForEach(tabIcons, id: \.1) { icon in
                            Button {
                                self.selectedIcon = icon
                                detector.setFlashlightMode(for: selectedIcon.1)
                            } label: {
                                VStack {
                                    IconTabVeiw(
                                        imageName: icon.0,
                                        title: LanguageManager.shared.localizedString(for: icon.1), index: 2, activeIndex: 0
                                    )
                                }
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
    SoundDetectionView(tabIcons: icons, selectedIcon: ("snapping","Snapping","ambulance"))
}
