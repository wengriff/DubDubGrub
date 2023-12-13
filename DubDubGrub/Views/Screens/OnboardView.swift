//
//  OnboardView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 05/11/2023.
//

import SwiftUI

struct OnboardView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    XDismissButton()
                }
                .padding()
            }
            Spacer()
            LogoView(frameWidth: 250)
                .padding(.bottom)
            VStack {
                OnboardInfoView(imageName: "building.2.crop.circle", title: "Restaurant Locations", description: "Find place to dine around the convention center")
            }
            VStack {
                OnboardInfoView(imageName: "checkmark.circle", title: "Check In", description: "Let other iOS devs know where you are")
            }
            VStack {
                OnboardInfoView(imageName: "person.2.circle", title: "Find Friends", description: "See where other iOS devs are and join the party")
            }
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    OnboardView()
}

fileprivate struct OnboardInfoView: View {
    
    var imageName: String
    var title: String
    var description: String
    var body: some View {
        HStack(spacing: 26) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.brandPrimary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .bold()
                Text(description)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}
