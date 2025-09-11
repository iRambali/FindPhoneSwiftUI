//
//  OnBoardingView.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 11/09/25.
//

import SwiftUI


struct OnBoardingView: View {
    @State private var currentPage = 0
    let totalPages = 4
    var onFinish: () -> Void
    
    var body: some View {
        VStack {
            
            TabView(selection: $currentPage) {
                OnboardingPage(
                    image: "sparkles",
                    title: "Welcome to Clap & Flash",
                    subtitle: "Find your phone using sound detection or play with flashlight effects."
                ).tag(0)
                
                OnboardingPage(
                    image: "hands.clap",
                    title: "Clap, Snap, or Say Hello!",
                    subtitle: "Your phone will respond with sound and flashlight flicker."
                ).tag(1)
                
                OnboardingPage(
                    image: "slider.horizontal.3",
                    title: "Make It Yours",
                    subtitle: "Choose fun sounds, adjust sensitivity, set timers, and switch languages."
                ).tag(2)
                
                OnboardingPage(
                    image: "mic.and.signal.meter",
                    title: "Permissions Needed",
                    subtitle: "Microphone: detect claps/snaps\nFlashlight: blink or create effects"
                ).tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // hide default dots
            
                       
            // Bottom buttons
            HStack {
                
                if currentPage < totalPages - 1 {
                    Button("Skip") {
                        currentPage = totalPages - 1
                    }
                    .font(.App.buttonTitle)
                    .foregroundColor(.accentColor)
                    .padding()
                }
                
                
                Spacer()
                
                // Custom Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.accentColor : Color.gray.opacity(0.3))
                            .frame(width: index == currentPage ? 12 : 8,
                                   height: index == currentPage ? 12 : 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                
                Spacer()
                if currentPage < totalPages - 1 {
                    Button("Next") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .font(.App.buttonTitle)
                    .padding()
                } else {
                    Button("Get Started") {
                        onFinish()
                    }
                    .font(.App.buttonTitle)
                    .padding()
                }
            }
            .padding()
        }
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.App.heading)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.App.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
    }
}


struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(onFinish: {
            print("on boarded")
        })
    }
}


/*
struct OnBoardingView : View {
    @State var currentIntex: Int = 0
    let total = 4
    var onFinish: () -> Void
    var body: some View {
        VStack(spacing: 12){
            TabView(selection: $currentIntex){
                Text("First Tab")
                    .tag(0)
                
                Text("Second Tab")
                    .tag(1)
                
                Text("Third Tab")
                    .tag(2)
                
                Text("Forth Tab")
                    .tag(3)
                
            }
            .tabViewStyle(PageTabViewStyle())
            
            Spacer()
            
            HStack(spacing: 12){
                if currentIntex < total - 1 {
                    Button("Skip"){
                        currentIntex = 3
                    }
                }else{
                    Button(action: {
                        print("button hidden")
                    }){
                        Text("Skip")
                            .disabled(true)
                    }
                    
//                    .isHidden(true)
                }
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<total, id: \.self){ index in
                        Circle()
                            .fill(index == currentIntex ? Color.accentColor : Color.gray.opacity(0.3))
                            .frame(width: index == currentIntex ? 12 : 8 ,
                                  height: index == currentIntex ? 12 : 8)
                            .animation(.easeInOut, value: currentIntex)
                    }
                }
                Spacer()
                
                if currentIntex < total - 1 {
                    Button("Next"){
                        withAnimation {
                            currentIntex += 1
                        }
                    }
                }else{
                    Button("Get Started"){
                        onFinish()
                    }
                }
            }
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(onFinish:{
            print(">>> Onboarding finished")
        })
    }
}
*/
