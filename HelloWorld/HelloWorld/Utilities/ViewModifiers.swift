//
//  ViewModifiers.swift
//  HelloWorld
//
//  Created by Larry N on 11/23/20.
//

import SwiftUI
import SDWebImageSwiftUI

// For images in ProfileSettings
private struct AvatarImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .shadow(radius: 15)
            .overlay(Circle().stroke(Color.white, lineWidth: 8))
            .frame(width: 125, height: 125)
    }
}

private struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
    }
}

extension View {
    func imageStyle() -> some View {
        self.modifier(AvatarImage())
    }
    
    func shadowStyle() -> some View {
        self.modifier(Shadow())
    }
}

