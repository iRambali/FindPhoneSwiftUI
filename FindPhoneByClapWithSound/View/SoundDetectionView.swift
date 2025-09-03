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
    
    
    var tabIcons:[(String, String)]
    @State var selectedIcon: (String, String)
    
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
                        .font(.title3)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                Text(LanguageManager.shared.localizedString(for: "sound_detection"))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding()
            .padding(.leading)
            
            //detected sound
            VStack {
                SoundAnimationView(iconImage: selectedIcon.0)
            }
            .padding(.top, 50)
            
            
            VStack {
                Text(LanguageManager.shared.localizedString(for: selectedIcon.1))
                    .font(Font.system(size: 24, weight: .bold))
                    .foregroundColor(Color.white)
            }
            .padding(.top, 50)
            
            
            VStack {
                Button(action: {
                    print("Button tapped!")
                    isTapped.toggle()
                    
//                  isTapped ? detector.startListening() : detector.stopListening()
                    if isTapped {
                        detector.startListening()
                    }else {
                        detector.stopListening()
                        detector.stopAlarm()
//                        detector.turnOffFlashlight()
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
                        
                        Text(LanguageManager.shared.localizedString(for: "activate_clap_detection"))
                            .font(.system(size: 18, weight: .bold))
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
                                if selectedIcon.1 == "light_house_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .lighthouse
                                    }
                                }else if selectedIcon.1 == "fire_light_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .fireLight
                                    }
                                }else if selectedIcon.1 == "flicker_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .flicker
                                    }
                                }else if selectedIcon.1 == "standard_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .standard
                                    }
                                }else if selectedIcon.1 == "green_light_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .greenLight
                                    }
                                }else if selectedIcon.1 == "strobe_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .strobe
                                    }
                                }else if selectedIcon.1 == "sos_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .sos
                                    }
                                }else if selectedIcon.1 == "party_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .party
                                    }
                                }else if selectedIcon.1 == "dim_title" {
                                    DispatchQueue.main.async {
                                        detector.flashlightMode = .dim
                                    }
                                }
                                
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
    SoundDetectionView(tabIcons: icons, selectedIcon: ("snapping","Snapping"))
}
