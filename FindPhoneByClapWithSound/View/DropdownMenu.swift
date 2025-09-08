//
//  DropdownMenu.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 08/09/25.
//

import SwiftUI

enum SoundSensitivity: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { self.rawValue } // required for ForEach
    
    
    var value: Double {
        switch self {
        case .low: return -20.0   // example volume multiplier
        case .medium: return -5.0
        case .high: return 10.0
        }
    }
}

enum TimeIntervalOption: String, CaseIterable, Identifiable {
    case tenSec = "10 Seconds"
    case fifteenSec = "15 Seconds"
    case twentySec = "20 Seconds"
    case thirtySec = "30 Seconds"

    var id: String { self.rawValue }
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
                    Text(selectedItem.rawValue)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .regular))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                }
                .padding()
                .background(Color.white)
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
                            Text(item.rawValue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .foregroundColor(.black)
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
