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
      .overlay(Circle().stroke(Constants.gradient, lineWidth: 8))
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

extension View {
  func imageStyle() -> some View {
    self.modifier(AvatarImage())
  }
  
  func shadowStyle() -> some View {
    self.modifier(Shadow())
  }
}

struct PrimaryButtonStyle: ButtonStyle {
  var condition: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    return PrimaryButton(configuration: configuration, condition: condition)
  }
  
  struct PrimaryButton: View {
    let configuration: Configuration
    let condition: Bool
    
    var body: some View {
      return configuration.label
        .padding(8)
        .frame(width: Constants.buttonWidth)
        .foregroundColor(condition ? .white : .secondary)
        .background(
          LinearGradient(
            gradient: Gradient(
              colors: [
                condition ? Color.red : Constants.secondaryColor,
                condition ? Color.blue : Constants.secondaryColor
              ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        )
        .shadowStyle()
        .offset(y: 20)
    }
  }
}
