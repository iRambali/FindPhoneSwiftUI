//
//  DropdownMenu.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 08/09/25.
//

import SwiftUI

enum SoundSensitivity: String, CaseIterable, Identifiable {
    case low = "low"
    case medium = "medium"
    case high = "high"

    var id: String { self.rawValue } // required for ForEach
    
    
    var value: Double {
        switch self {
        case .low: return -25.0   // example volume multiplier
        case .medium: return -15.0
        case .high: return -5.0
        }
    }
}

enum TimeIntervalOption: String, CaseIterable, Identifiable {
    case tenSec = "ten_seconds"
    case fifteenSec = "fifteen_seconds"
    case twentySec = "twenty_seconds"
    case thirtySec = "thirty_seconds"

    var id: String { self.rawValue }
    var value: Double {
        switch self {
        case .tenSec: return 10.0
        case .fifteenSec: return 15.0
        case .twentySec: return 20.0
        case .thirtySec: return 30.0
        }
    }
}

struct DropdownMenu<T: CaseIterable & Identifiable & RawRepresentable>: View where T.RawValue == String {
    
    
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
    
    @Binding var selectedItem: T
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 10) {
            // Dropdown button
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(LanguageManager.shared.localizedString(for: selectedItem.rawValue))
                        .foregroundColor(.colorText)
                        .font(.App.buttonTitle)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.App.buttonTitle)
                        .foregroundColor(.colorText)
                        .frame(width: 30, height: 30)
                }
                .padding()
                .background(Color.blue.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            
            // Dropdown list
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(T.allCases)) { item in
                        Button(action: {
                            selectedItem = item
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            Text(LanguageManager.shared.localizedString(for: item.rawValue))
                                .font(.App.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .foregroundColor(.colorText)
                                .background(selectedItem == item ? Color.green.opacity(0.3) : Color.clear)
                        }
                        Divider()
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(radius: 2)
            }
        }
    }
}

#Preview {
    DropdownMenu(selectedItem: .constant(SoundSensitivity.low))
}
