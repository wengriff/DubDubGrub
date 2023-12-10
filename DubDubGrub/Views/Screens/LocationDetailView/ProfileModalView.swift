//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 14/11/2023.
//

import SwiftUI

struct ProfileModalView: View {
    
    @Binding var isShowingProfileModal: Bool
    
    var profile: DDGProfile
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(uiImage: profile.createAvatarImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .accessibilityHidden(true)
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .minimumScaleFactor(0.9)
                
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(Text("Works at \(profile.companyName)"))
                
                Text(profile.bio)
                    .minimumScaleFactor(0.75)
                    .accessibilityLabel(Text("Bio \(profile.bio)"))
            }
            .padding()
        }
    }
}

#Preview {
    ProfileModalView(isShowingProfileModal: .constant(true), profile: DDGProfile(record: MockData.profile))
}
