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
    @State private var showRegistration = false
    @ObservedObject var sessionStore = SessionStore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                TextField("email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    sessionStore.signIn(email: email, password: password)
                }, label: {
                    Text("Login")
                })
                                
                Text("Don't have an account? Sign up")
                    .font(.subheadline)
                    .padding()
                    .onTapGesture {
                        showRegistration.toggle()
                    }
                    .sheet(isPresented: $showRegistration, content: {
                        Register()

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
