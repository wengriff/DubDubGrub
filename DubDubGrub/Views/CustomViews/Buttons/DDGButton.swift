//
//  DDGButton.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 26/09/2023.
//

import SwiftUI

struct DDGButton: View {
    
    var title: String
    var color: Color = .brandPrimary
    
    var body: some View {
        Text(title)
            .bold()
            .frame(width: 280, height: 44)
            .background(color.gradient)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

#Preview {
    DDGButton(title: "Test")
}
