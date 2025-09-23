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
            
            //MARK: Navigation header
            NavigationHeader(
                title: "About Us"
            ) {
                dismiss()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center){
                    Image("appLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .background(Color.gray.opacity(0.3))
                }
                .cornerRadius(20)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Centered header section
                    VStack(spacing: 4) {
                        Text("FindPhoneByClapWithSounds")
                            .font(.App.title)
                            .foregroundColor(.colorText)

                        Text("Version: 1.0.0")
                            .font(.App.footer)
                            .foregroundColor(.colorText)
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // center these two lines

                    // Left-aligned description
                    Text("Find Phone by Clap With Sounds is a smart and fun utility app that helps you find your phone by clapping, whistling, or other custom sounds. Perfect for moments when your device is lost in silence!")
                        .multilineTextAlignment(.leading)
                        .padding(.top, 8)
                        .padding(.bottom, 35)
                        .font(.App.body)
                        .foregroundColor(.colorText)
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
                            .font(.App.title)
                            .foregroundColor(.colorText)
                            .padding(.bottom, 4)
                        Spacer()
                    }

                    HStack {
                        Image(systemName: "star.fill")
                            .font(.App.buttonTitle)
                        Text("Clap detection to find your phone")
                            .font(.App.body)
                            .foregroundColor(.colorText)
                    }

                    HStack {
                        Image(systemName: "star.fill")
                            .font(.App.buttonTitle)
                        Text("Whistle and shout support")
                            .font(.App.body)
                            .foregroundColor(.colorText)
                    }

                    HStack {
                        Image(systemName: "star.fill")
                            .font(.App.buttonTitle)
                        Text("Works even in silent mode")
                            .font(.App.body)
                            .foregroundColor(.colorText)
                    }

                    HStack {
                        Image(systemName: "star.fill")
                            .font(.App.buttonTitle)
                        Text("Custom ringtone and themes")
                            .font(.App.body)
                            .foregroundColor(.colorText)
                    }

                    HStack {
                        Image(systemName: "star.fill")
                            .font(.App.buttonTitle)
                        Text("Lightweight and battery-efficient")
                            .font(.App.body)
                            .foregroundColor(.colorText)
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
                        .font(.App.footer)
                        .foregroundStyle(Color.gray)
                    
                    Text("support@datability.com")
                        .font(.App.footer)
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
