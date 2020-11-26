//
//  LoginViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/25/20.
//

import Foundation

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
    
    // MARK:  Firebase Sign-in
    func signIn() {
        sessionStore.signIn(email: email, password: password) { [weak self] error in
            if error != nil {
                guard let self = self else { return }
                self.showAlert = true
                self.errorMessage = "\(String(describing: error!.localizedDescription))"
            }
        }
    }
}
