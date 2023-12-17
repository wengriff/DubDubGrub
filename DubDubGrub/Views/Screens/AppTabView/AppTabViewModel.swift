//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 05/12/2023.
//

import SwiftUI

extension AppTabView {
    
    final class AppTabViewModel: ObservableObject  {
        @Published var isShowingOnboardView: Bool = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = hasSeenOnboardView }
        }
        
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        func checkIfHasSeenOnboard() {
            if !hasSeenOnboardView { hasSeenOnboardView = true }
        }
    }
}

