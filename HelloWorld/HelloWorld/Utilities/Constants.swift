//
//  Constants.swift
//  HelloWorld
//
//  Created by Larry N on 11/23/20.
//

import SwiftUI

enum Constants {
  static let textColor = Color("TextColor")
  static let textFieldColor = Color("TextFieldColor")
  static let primary = Color("Primary")
  static let secondaryColor = Color("SecondaryColor")
  static let bubbleColor = Color("MessageBubbleColor")
  
  static let gradient = LinearGradient(
    gradient: Gradient(colors: [Color.red, Color.blue]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let red = Color("Red")
  static let orange = Color("Orange")
  static let green = Color("Green")
  static let blue = Color("Blue")
  static let teal = Color("Teal")
  static let purple = Color("Purple")
  static let gray = Color("Gray")

  static let contentWidth = UIScreen.main.bounds.width - 50
  static let buttonWidth = UIScreen.main.bounds.width - 150
}
