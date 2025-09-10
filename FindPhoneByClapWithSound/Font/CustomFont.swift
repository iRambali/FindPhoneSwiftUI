//
//  CustomFont.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 10/09/25.
//

import SwiftUI


extension Font {
    enum App {
        /// Navigation bar title (large & bold)
        /// Standard size: 34pt (Large Title in HIG)
        static let navigationTitle = Font.system(size: 28, weight: .bold, design: .default)
        
        /// Section / page heading
        /// Standard size: 28pt (Title in HIG)
        static let heading = Font.system(size: 22, weight: .semibold, design: .default)
        
        /// Subsection / small title
        /// Standard size: 22pt (Headline in HIG)
        static let title = Font.system(size: 16, weight: .medium, design: .default)
        
        /// Main body text
        /// Standard size: 17pt (Body in HIG)
        static let body = Font.system(size: 12, weight: .regular, design: .default)
        
        /// Footer / helper text
        /// Standard size: 13pt (Footnote in HIG)
        static let footer = Font.system(size: 10, weight: .regular, design: .default)
        
        static let buttonTitle = Font.system(size: 16, weight: .semibold, design: .default)
    }
}
