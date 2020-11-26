//
//  RegisterViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/25/20.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    private var sessionStore = SessionStore()
    
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var isLoading = false
    
    // MARK:  Validation
    var isFormCompleted: Bool {
        // returns true if all fields are filled
        Helper.validateForm(for: [email, password, firstName, lastName])
    }
    
    // MARK:  Firebase Sign-up
    func signUp() {
        isLoading.toggle()
        
        sessionStore.signUp(email: email, password: password, displayName: firstName) { [weak self] error in
            if error != nil {
                guard let self = self else { return }
                self.showAlert = true
                self.errorMessage = "\(String(describing: error!.localizedDescription))"
                self.isLoading.toggle()
            }
        }
    }
}
