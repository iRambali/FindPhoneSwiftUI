//
//  ContentView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 05/08/25.
//

import SwiftUI

struct ContentView: View {
    

        // 3 columns grid layout
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HStack {
                    Text(LanguageManager.shared.localizedString(for: "home_tab"))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    Button(action: {
                        print("Settings tapped")
                    }) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .padding()
                .padding(.leading)
                
                Spacer()
                ScrollView {
                    
                    Text(LanguageManager.shared.localizedString(for: "tagline_text"))
                        .font(.system(size: 18, design: .serif))
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .padding(.top, 30)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(icons, id: \.1) { icon in
                            NavigationLink(destination: SoundDetectionView()) {
                                IconTabVeiw(imageName: icon.0, title: LanguageManager.shared.localizedString(for: icon.1))
                            }
                        }
                    }
                    .padding(.all)
                    
                    VStack {
                        Text(LanguageManager.shared.localizedString(for: "rule_text"))
                        .font(.system(.body, design: .serif))
                        .foregroundColor(Color.white)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .lineSpacing(8)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white ,lineWidth: 2)
                        )
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text(makeAttributedText())
                            .font(.system(.body, design: .serif))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing)
                    
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        Text(LanguageManager.shared.localizedString(for: "version_text"))
                            .font(.system(.body, design: .serif))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 18)
                }
            }
            .background(Color.colorBackground)
        }
    }
    
    
    func makeAttributedText() -> AttributedString {
        var str = AttributedString(LanguageManager.shared.localizedString(for: "consent_text"))
        
        if let termsRange = str.range(of: LanguageManager.shared.localizedString(for: "terms_text")) {
            str[termsRange].link = URL(string: "https://cdn.izooto.com/app-policy/findphonebysounds.html")
            str[termsRange].foregroundColor = .blue
            str[termsRange].underlineStyle = .single
        }
        
        if let privacyRange = str.range(of: LanguageManager.shared.localizedString(for: "privacy_text")) {
            str[privacyRange].link = URL(string: "https://cdn.izooto.com/app-policy/findphonebysounds.html")
            str[privacyRange].foregroundColor = .blue
            str[privacyRange].underlineStyle = .single
        }
        return str
    }
}

#Preview {
    ContentView()
}
