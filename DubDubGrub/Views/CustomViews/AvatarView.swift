//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 26/09/2023.
//

import SwiftUI

struct AvatarView: View {
    
    var size: CGFloat
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AvatarView(size: 90, image: PlaceholderImage.avatar)
}
