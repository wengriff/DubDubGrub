//
//  LoadingView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 12/11/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                .scaleEffect(2.5)
                .offset(y: -40)
        }
    }
}

#Preview {
    LoadingView()
}
