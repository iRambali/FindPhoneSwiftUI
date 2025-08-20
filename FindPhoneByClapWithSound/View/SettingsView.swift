////
////  SettingsView.swift
////  FindPhoneByClapWithSound
////
////  Created by Rambali Kumar on 20/08/25.
////
//


import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            VStack{
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
                    Text("Settings")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding()
                .padding(.leading)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // MARK: - General Section
                        SectionHeader(title: "General")
                        NavigationLink(destination: FlashModeView()) {
                            SettingRow(icon: "lightbulb.max.fill",
                                       title: "More Flash Mode",
                                       background: Color.white)
                        }
                        
                        // MARK: - Language Section
                        SectionHeader(title: "Change Language")
                        
                        NavigationLink(destination: SetLanguageView()) {
                            SettingRow(icon: "globe",
                                       title: "Change Language",
                                       background: Color.white)
                        }
                        
                        // MARK: - Connect with Us Section
                        SectionHeader(title: "Connect with us")
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: AboutUsView()) {
                                ConnectRow(icon: "info.circle.fill",
                                           title: "About Us", iconColor: Color.black)
                            }
                            
                            Divider()
                                .frame(height: 1)              // thickness
                                .background(Color.gray.opacity(0.8))  // dark color
                            
                            ConnectRow(icon: "star",
                                       title: "Rate Us", iconColor: Color.gray)
                            
                            Divider()
                                .frame(height: 1)              // thickness
                                .background(Color.gray.opacity(0.8))  // dark color
                            
                            ConnectRow(icon: "info.bubble",
                                       title: "Feedback", iconColor: Color.blue)
                            
                            Divider()
                                .frame(height: 1)              // thickness
                                .background(Color.gray.opacity(0.8))  // dark color
                            
                            Button {
                                openURL("https://cdn.izooto.com/app-policy/findphonebysounds.html") // Replace with real URL
                            } label: {
                                ConnectRow(icon: "exclamationmark.shield", title: "Privacy Policy", iconColor: Color.green)
                            }
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(radius: 2, y: 1)
                    }
                    .padding()
                }
            }
            .background(Color.colorBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // Helper to open external links
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Components

//MARK: Section Header title view
struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(.white)
    }
}

//MARK: Setting Row
struct SettingRow: View {
    var icon: String
    var title: String
    var background: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(Font.system(size: 24, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

//MARK: Connect with us row view
struct ConnectRow: View {
    var icon: String
    var title: String
    var iconColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(Font.system(size: 24, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
