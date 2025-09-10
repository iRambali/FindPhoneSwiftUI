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
    
    @State private var isExpanded = false
    @AppStorage("selectedLevel") private var selectedLevelRaw: String = SoundSensitivity.allCases.first!.rawValue
    @AppStorage("selectedInterval") private var selectedIntervalRaw: String = TimeIntervalOption.allCases.first!.rawValue
    private var selectedLevel: Binding<SoundSensitivity> {
        Binding(
            get: { SoundSensitivity(rawValue: selectedLevelRaw) ?? .low },
            set: { selectedLevelRaw = $0.rawValue }
        )
    }
    private var selectedInterval: Binding<TimeIntervalOption> {
        Binding(
            get: { TimeIntervalOption(rawValue: selectedIntervalRaw) ?? .tenSec },
            set: { selectedIntervalRaw = $0.rawValue }
        )
    }

    
    var body: some View {
        
        NavigationStack {
            VStack{
                //MARK: Navigation Header
                NavigationHeader(title: LanguageManager.shared.localizedString(for: "settings")) {
                    dismiss()
                }
                
                //MARK: body
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // MARK: - General Section
                        SectionHeader(title: LanguageManager.shared.localizedString(for: "general"))
                        NavigationLink(destination: FlashModeView()) {
                            SettingRow(icon: "lightbulb.max.fill",
                                       title: LanguageManager.shared.localizedString(for: "more_flash_mode"),
                                       background: Color.blue.opacity(0.3))
                        }
                        
                        // MARK: - Language Section
                        SectionHeader(title: LanguageManager.shared.localizedString(for: "change_language"))
                        
                        NavigationLink(destination: SetLanguageView()) {
                            SettingRow(icon: "globe",
                                       title: LanguageManager.shared.localizedString(for: "change_language"),
                                       background: Color.blue.opacity(0.3))
                        }
                        
                        //MARK: - Level
                        SectionHeader(title: "Sound sensitivity")
                        DropdownMenu(selectedItem: selectedLevel)
                        
                        SectionHeader(title: "Auto sound off")
                        DropdownMenu(selectedItem: selectedInterval)
                                                
                        // MARK: - Connect with Us Section
                        SectionHeader(title: LanguageManager.shared.localizedString(for: "connect_with_us"))
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: AboutUsView()) {
                                ConnectRow(icon: "info.circle.fill",
                                           title: LanguageManager.shared.localizedString(for: "about_us"), iconColor: Color.black)
                            }
                            
                            Divider()
                                .frame(height: 1)              // thickness
                                .background(Color.gray.opacity(0.8))  // dark color
                            
                            ConnectRow(icon: "star",
                                       title: LanguageManager.shared.localizedString(for: "rate_us"), iconColor: Color.gray)
                            
                            Divider()
                                .frame(height: 1)              // thickness
                                .background(Color.gray.opacity(0.8))  // dark color
                            
                            ConnectRow(icon: "info.bubble",
                                       title: LanguageManager.shared.localizedString(for: "feedback"), iconColor: Color.blue)
                            Divider()
                                .frame(height: 1)              // thickness
                                .background(Color.gray.opacity(0.8))  // dark color
                            
                            Button {
                                openURL("https://apps.apple.com/app/id739535953") // Replace with real URL
                            } label: {
                                ConnectRow(icon: "square.and.arrow.up", title: LanguageManager.shared.localizedString(for: "Share App"), iconColor: Color.primary)
                            }
                            
                            Divider()
                                .frame(height: 1)              // thickness
                                .background(Color.gray.opacity(0.8))  // dark color
                            
                            Button {
                                openURL("https://cdn.izooto.com/app-policy/findphonebysounds.html") // Replace with real URL
                            } label: {
                                ConnectRow(icon: "exclamationmark.shield", title: LanguageManager.shared.localizedString(for: "privacy_policy"), iconColor: Color.green)
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
            .font(.App.heading)
            .fontWeight(.semibold)
            .foregroundColor(.colorText)
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
                .font(.App.heading)
                .foregroundColor(.black)
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.App.buttonTitle)
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
                .font(.App.heading)
                .foregroundColor(iconColor)
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.App.buttonTitle)
                .foregroundColor(.colorText)
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

#Preview {
    SettingsView()
}
