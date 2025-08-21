//
//  FlashModeView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 20/08/25.
//

import SwiftUI

struct FlashModeView: View {
    @Environment(\.dismiss) var dismiss
    // 3 columns grid layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        
        NavigationStack{
            VStack(spacing: 0){
                //MARK:  Navigation Header
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
                    Text("Flash Mode")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding()
                .padding(.leading)
                
                ScrollView{
                    VStack(alignment: .center, spacing: 0){
                        Text("Multiple Lights")
                            .font(.system(size: 18, design: .serif))
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .padding(.top, 30)
                    }
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(lightIcons, id: \.1) { icon in
                            NavigationLink(destination: SoundDetectionView()) {
                                IconTabVeiw(imageName: icon.0, title: LanguageManager.shared.localizedString(for: icon.1))
                            }
                        }
                    }
                    .padding(.all)
                    
                }
                
                
                
                
                
                
                Spacer()
            }
            .background(Color.colorBackground)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    FlashModeView()
}
