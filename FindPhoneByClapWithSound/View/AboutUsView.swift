//
//  AboutUsView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 20/08/25.
//

import SwiftUI

struct AboutUsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
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
                Text("About Us")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding()
            .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center){
                    Image("snapping")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(Color.white)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Centered header section
                    VStack(spacing: 4) {
                        Text("FindPhoneByClapWithSounds")
                            .font(.system(size: 18, weight: .semibold, design: .serif))

                        Text("Version: 1.0.0")
                            .font(.system(size: 12, weight: .regular, design: .serif))
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // center these two lines

                    // Left-aligned description
                    Text("Find Phone by Clap With Sounds is a smart and fun utility app that helps you find your phone by clapping, whistling, or other custom sounds. Perfect for moments when your device is lost in silence!")
                        .multilineTextAlignment(.leading)
                        .padding(.top, 8)
                        .padding(.bottom, 50)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding()

                
                
                VStack(alignment: .leading, spacing: 12) {   // leading alignment + line spacing
                    HStack {
                        Spacer()
                        Text("Key Features")
                            .font(Font.system(size: 18, weight: .semibold, design: .serif))
                            .padding(.bottom, 4)
                        Spacer()
                    }

                    HStack {
                        Image(systemName: "star.fill")
                        Text("Clap detection to find your phone")
                    }

                    HStack {
                        Image(systemName: "star.fill")
                        Text("Whistle and shout support")
                    }

                    HStack {
                        Image(systemName: "star.fill")
                        Text("Works even in silent mode")
                    }

                    HStack {
                        Image(systemName: "star.fill")
                        Text("Custom ringtone and themes")
                    }

                    HStack {
                        Image(systemName: "star.fill")
                        Text("Lightweight and battery-efficient")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading) // keep VStack full width + align left
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding()

                
                VStack(alignment: .center, spacing: 8){
                    Text("Developed with ❤️ by Datability Team")
                        .font(.system(size: 14, weight: .none, design: .serif))
                        .foregroundStyle(Color.gray)
                    
                    Text("support@datability.com")
                        .font(.system(size: 12, weight: .none, design: .serif))
                        .foregroundStyle(Color.green .opacity(0.3))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding()
            }
            
            Spacer()
        }
        .background(Color.colorBackground)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AboutUsView()
}
