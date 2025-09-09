//
//  SoundAnimationView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 19/08/25.
//

import SwiftUI

struct SoundAnimationView: View {
    var iconImage: String
    @State private var animate = false
    
    var body: some View {
        
        ZStack{
            Image(iconImage)
                .resizable()
                .frame(width: 92, height: 92)
            
                Circle()
                .stroke(Color.colorFirstCircle, lineWidth: 10)
                .frame(width: 150)
            
            Circle()
            .stroke(Color.colorSecondCircle, lineWidth: 10)
            .frame(width: 160)
            
            Circle()
            .stroke(Color.colorThirdCircle, lineWidth: 10)
            .frame(width: 170)
            
            Circle()
            .stroke(Color.colorForthCircle, lineWidth: 10)
            .frame(width: 180)
            
            Circle()
            .stroke(Color.colorFifthCircle, lineWidth: 10)
            .frame(width: 190)
            
            Circle()
                .stroke(Color.colorSeventhCircle, lineWidth: 10)
            .frame(width: 200)
            
            Circle()
            .stroke(Color.colorEightCircle, lineWidth: 10)
            .frame(width: 210)
            
            Circle()
            .stroke(Color.colorNinethCircle, lineWidth: 10)
            .frame(width: 220)
    
            
        }
        .onAppear {
            animate = true
        }
//        .background(Color.colorBackground)
        
    }
}

//#Preview {
//    SoundAnimationView()
//}

struct SoundAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        SoundAnimationView(iconImage: "clap")
            .previewLayout(.fixed(width: 320, height: 320))
    }
}
