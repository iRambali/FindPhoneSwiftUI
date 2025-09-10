//
//  SetLanguageView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 20/08/25.
//

import SwiftUI

struct SetLanguageView: View {
    @State private var selectedLanguage: String = LanguageManager.shared.currentLanguage.rawValue
    @Environment(\.dismiss) var dismiss
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            //MARK: Header Navigation view
            HStack {
                Text("Set Language")
                    .font(.App.navigationTitle)
                    .foregroundStyle(.colorText)
                Spacer()
                
                Button (action: {
                    hasLaunchedBefore = true
                    print("Language selected successfully!")
                    if let lang = LanguageManager.AppLanguage(rawValue: selectedLanguage) {
                        LanguageManager.shared.currentLanguage = lang
                        print("Current Language : \(LanguageManager.shared.currentLanguage)")
                        // Restart UI so translations apply
                        UIApplication.shared.windows.first?.rootViewController =
                        UIHostingController(rootView: ContentView())
                    }
                    dismiss()
                }) {
                    Image(systemName: "checkmark")
                        .font(.App.buttonTitle)
                        .foregroundStyle(Color.colorText)
                }
            }
            .background(Color.colorBackground)
            .padding()
            .padding(.leading)
            
            ScrollView(){
                VStack(spacing: 16) {
                    ForEach(languages) { language in
                        LanguageRow(language: language, isSelected: selectedLanguage == language.code)
                            .onTapGesture {
                                selectedLanguage = language.code
                            }
                    }
                }
                .padding()
                
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.colorBackground)
        .navigationBarBackButtonHidden(true)
    }
}


//MARK: Language tab View
struct LanguageRow: View {
    let language: Language
    let isSelected: Bool
    
    var body: some View {
        HStack {
            // Flag
            Text(language.flag)
                .font(.system(size: 50))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(language.name)
                    .font(.App.title)
                Text(language.subtitle)
                    .font(.App.body)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Radio button
            Circle()
                .strokeBorder(isSelected ? Color.purple : Color.gray, lineWidth: 2)
                .background(
                    Circle()
                        .fill(isSelected ? Color.purple : Color.clear)
                        .frame(width: 15, height: 15)
                )
                .frame(width: 30, height: 30)
        }
        .padding()
        .background(isSelected ? Color.yellow.opacity(0.3) : Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    SetLanguageView()
}
