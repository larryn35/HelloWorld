//
//  RegisterViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/25/20.
//

import Foundation

final class RegisterViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var firstName = ""
  @Published var lastName = ""
  
  // Checks if fields are valid, returns false if any of the fields are invalid
  var isFormCompleted: Bool {
    Helper.validateForm(for: [email, password, firstName, lastName])
  }
  
  // Clear fields after registering
  func clearFields() {
    email = ""
    password = ""
    firstName = ""
    lastName = ""
  }
}
