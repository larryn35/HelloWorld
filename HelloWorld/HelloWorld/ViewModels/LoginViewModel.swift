//
//  LoginViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/25/20.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    private var sessionStore = SessionStore()
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var showAlert = false
    
    // MARK:  Validation
    var isFormCompleted: Bool {
        !email.isEmpty && password.count >= 6
    }
    
    func signIn() {
        sessionStore.signIn(email: email, password: password) { [weak self] success, error  in
            if !success, error != nil {
                guard let self = self else { return }
                self.showAlert = true
                self.errorMessage = "\(String(describing: error!.localizedDescription))"
            }
        }
    }
}
