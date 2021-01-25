//
//  Extensions.swift
//  HelloWorld
//
//  Created by Larry N on 11/25/20.
//

import SwiftUI

// Dismiss keyboard on tap
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Text format for WelcomeView
extension Text {
  func welcomeFormat(optionNumber: Int, _ optionSelected: Int) -> some View {
    self
      .fontWeight(.bold)
      .foregroundColor(optionSelected == optionNumber ? Constants.textColor : .secondary)
      .padding(.vertical, 10)
      .frame(width: (Constants.contentWidth) / 2)
      .background(
        optionSelected == optionNumber ? Constants.textFieldColor : Constants.secondaryColor
      )
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}
