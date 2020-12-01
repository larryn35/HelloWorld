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
            .overlay(Circle().stroke(Constants.primary, lineWidth: 8))
            .frame(width: 125, height: 125)
            .shadow(radius: 15)
    }
}

private struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
    }
}

private struct ButtonStyle: ViewModifier {
    var condition: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .frame(width: Constants.buttonWidth)
            .foregroundColor(.white)
            .background(condition ? Color.red : Color.gray.opacity(0.8))
            .shadowStyle()
    }
}

extension View {
    func imageStyle() -> some View {
        self.modifier(AvatarImage())
    }
    
    func shadowStyle() -> some View {
        self.modifier(Shadow())
    }
    
    func buttonStyle(condition: Bool) -> some View {
        self.modifier(ButtonStyle(condition: condition))
    }
}

