//
//  Login.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Login: View {
    
    @State var email = ""
    @State var password = ""
    @ObservedObject var sessionStore = SessionStore()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    sessionStore.signIn(email: email, password: password)
                }, label: {
                    Text("Login")
                })
                
                Button(action: {
                    sessionStore.signUp(email: email, password: password)
                }, label: {
                    Text("Sign up")
                })

            }
            .navigationTitle("Welcome")
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
