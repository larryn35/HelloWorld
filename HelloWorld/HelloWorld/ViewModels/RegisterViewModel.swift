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
    
    // MARK:  Validation
    var isFormCompleted: Bool {
        // returns true if all fields are filled
        Helper.validateForm(for: [email, password, firstName, lastName])
    }
}
