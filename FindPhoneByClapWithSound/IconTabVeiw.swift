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
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(imageName)
                .resizable()
                .frame(width: 62, height: 62)
            
            Text(title)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color.black)
                .padding(.top, 8)
        }
        .frame(width: 80, height: 120, alignment: .center)
        .padding()
        .background(Color.white)
        .shadow(radius: 8)
        .cornerRadius(30)
    }
}

//#Preview {
//    IconTabVeiw()
//        .previewLayout(.fixed(width: 340, height: 340))
//}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        IconTabVeiw(imageName: "snapping", title: "Snapping")
            .previewLayout(.fixed(width: 200, height: 200))
    }
}

