//
//  FindPhoneByClapWithSoundApp.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 05/08/25.
//

import SwiftUI

@main
struct FindPhoneByClapWithSoundApp: App {
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                ContentView()
            } else {
                SetLanguageView()
            }
        }
    }
}
