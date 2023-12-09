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
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 60)
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                
                Text(profile.bio)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .padding()
                
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(Button {
                withAnimation {
                    isShowingProfileModal = false
                }
            } label: {
                XDismissButton()
            }, alignment: .topTrailing)
            
            Image(uiImage: profile.createAvatarImage())
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(x: 0, y: -120)
        }
    }
}

#Preview {
    ProfileModalView(isShowingProfileModal: .constant(true), profile: DDGProfile(record: MockData.profile))
}
