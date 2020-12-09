//
//  LoginViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/25/20.
//

import Foundation

final class LoginViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  
  // Checks if email and password fields are valid
  var isFormCompleted: Bool {
    !email.isEmpty && password.count >= 6
  }
  
  // Clears email and password fields after logging in
  func clearFields() {
    email = ""
    password = ""
  }
}
