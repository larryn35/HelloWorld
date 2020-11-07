//
//  Register.swift
//  HelloWorld
//
//  Created by Larry N on 11/5/20.
//

import SwiftUI

struct Register: View {
    
    @State var email = ""
    @State var password = ""
    @State var firstName = ""
    @State var lastName = ""
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var sessionStore = SessionStore()
    @ObservedObject var userProfile = UserProfileViewModel()
            
    var body: some View {
        NavigationView {
            VStack {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                                                            
                    sessionStore.signUp(email: email, password: password) {
                        
                        userProfile.createProfile(firstName: firstName, lastName: lastName, email: email)
                        
                        self.presentationMode.wrappedValue.dismiss()

                    }
                    
                }, label: {
                    Text("Sign up")
                })
                
            }
            .navigationTitle("Welcome")
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
