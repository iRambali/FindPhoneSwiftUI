//
//  IconTabVeiw.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 05/08/25.
//

import SwiftUI

struct IconTabVeiw: View {
    
    let imageName: String
    let title: String
    let index: Int
    let activeIndex: Int
    @State private var animate = false
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)
                .scaleEffect(animate ? 1.2 : 1.0)
                .opacity(animate ? 1.2 : 1.0)
                .padding(.bottom, -12)
                
            Text(title)
                .font(.App.title)
                .foregroundColor(Color.colorText)
                .padding(.top, 8)
        }
        .onChange(of: activeIndex) { newValue in
            if newValue == index {
                runCycle()
            }
        }
        .frame(width: 110, height: 110) // make it square
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)
        )
        
    }
    
    private func runCycle() {
        // scale UP
        withAnimation(.easeInOut(duration: 1.5)) {
            animate = true
        }
        
        // scale DOWN after 0.4s
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 1.5)) {
                animate = false
            }
        }
    }
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        IconTabVeiw(imageName: "snapping", title: "Snapping", index: 0, activeIndex: 0)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}

