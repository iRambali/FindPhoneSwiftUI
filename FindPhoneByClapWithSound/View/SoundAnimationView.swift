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
            StrokedCircle(color: .colorFirstCircle, diameter: 150)
            StrokedCircle(color: .colorSecondCircle, diameter: 160)
            StrokedCircle(color: .colorThirdCircle, diameter: 170)
            StrokedCircle(color: .colorForthCircle, diameter: 180)
            StrokedCircle(color: .colorFifthCircle, diameter: 190)
            StrokedCircle(color: .colorSeventhCircle, diameter: 200)
            StrokedCircle(color: .colorEightCircle, diameter: 210)
            StrokedCircle(color: .colorNinethCircle, diameter: 220)
        }
        .padding()
        .onAppear {
            animate = true
        }
//        .background(Color.colorBackground)
        
    }
}

struct StrokedCircle: View {
    var color: Color
    var diameter: CGFloat
    var lineWidth: CGFloat = 10
    
    var body: some View {
        Circle()
            .stroke(color, lineWidth: lineWidth)
            .frame(width: diameter, height: diameter)
    }
}

//#Preview {
//    SoundAnimationView()
//}

struct SoundAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        SoundAnimationView(iconImage: "clap")
            .previewLayout(.fixed(width: 350, height: 350))
    }
}
