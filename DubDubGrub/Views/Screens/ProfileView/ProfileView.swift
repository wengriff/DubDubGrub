//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 23/09/2023.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 16) {
                    ZStack {
                        AvatarView(size: 84, image: viewModel.avatar)
                        ProfileImageView(image: viewModel.avatar)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(Text("Profile Photo"))
                    .accessibilityHint(Text("Opens the iPhone's photo picker"))
                    .padding(.leading, 12)
                    .onTapGesture { viewModel.isShowingPhotoPicker = true }
                    
                    VStack(spacing: 1) {
                        TextField("First Name", text: $viewModel.firstName)
                            .profileNameStyle()
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .profileNameStyle()
                        
                        TextField("Company Name", text: $viewModel.companyName)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        CharactersRemainView(currentCount: viewModel.bio.count)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                        if viewModel.isCheckedIn {
                            Button {
                                viewModel.checkOut()
                            } label: {
                                CheckOutButton()
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    BioTextEditor(text: $viewModel.bio)
                }
                .padding(.horizontal, 20)
                Spacer()
                Button {
                    viewModel.determineButtonAction()
                } label: {
                    DDGButton(title: viewModel.buttonTitle)
                }
                .padding(.bottom)
            }
            if viewModel.isLoading { LoadingView() }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .toolbar {
            Button {
                dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
        .task {
            viewModel.getProfile()
            viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .sheet(isPresented: $viewModel.isShowingPhotoPicker) {
            PhotoPicker(image: $viewModel.avatar)
        }
    }
}

fileprivate struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

fileprivate struct ProfileImageView: View {
    
    var image: UIImage
    
    var body: some View {
        ZStack {
            AvatarView(size: 84, image: image)
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y: 30)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("Profile Photo"))
        .accessibilityHint(Text("Opens the iPhone's photo picker"))
        .padding(.leading, 12)
    }
}

fileprivate struct CharactersRemainView: View {
    var currentCount: Int
    var body: some View {
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundColor(currentCount <= 100 ? .brandPrimary : Color(.systemPink))
        +
        Text(" Characters Remain")
            .font(.callout)
            .foregroundColor(.secondary)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}

struct CheckOutButton: View {
    
    var body: some View {
        Label("Check Out", systemImage: "mappin.and.ellipse")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(10)
            .frame(height: 28)
            .background(Color.grubRed)
            .cornerRadius(8)
            .accessibilityLabel(Text("Check out of current location."))
        
    }
}

struct BioTextEditor: View {
    
    var text: Binding<String>
    
    var body: some View {
        TextEditor(text: text)
            .frame(height: 100)
            .overlay {
                RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1)
            }
        //            .accessibilityLabel(Text("Bio, \(viewModel.bio)"))
            .accessibilityHint(Text("This textfield is for your bio and has a 100 characters maximum."))
    }
}
