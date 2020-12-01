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
    
    // MARK:  Validation
    var isFormCompleted: Bool {
        !email.isEmpty && password.count >= 6
    }
}
