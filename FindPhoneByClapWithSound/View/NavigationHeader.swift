//
//  NavigationHeader.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 10/09/25.
//


import SwiftUI

struct NavigationHeader: View {
    var title: String
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.App.buttonTitle)
                    .foregroundColor(Color.colorText)
            }
            
            Spacer()
            
            Text(title)
                .font(.App.navigationTitle)
                .foregroundColor(Color.colorText)
            
            Spacer()
        }
        .padding()
        .padding(.leading)
    }
}

struct NavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHeader(title: "NavigationTitle", onBack: {
            print("button tapped")
        })
            .previewLayout(.fixed(width: 360, height: 90))
    }
}
