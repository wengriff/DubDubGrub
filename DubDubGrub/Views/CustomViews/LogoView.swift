//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 05/11/2023.
//

import SwiftUI

struct LogoView: View {
    
    var frameWidth: CGFloat
    var body: some View {
        Image(decorative: "ddg-map-logo")
            .resizable()
            .scaledToFit() // will keep its aspect ratio
            .frame(height: frameWidth)
    }
}

#Preview {
    LogoView(frameWidth: 250)
}
