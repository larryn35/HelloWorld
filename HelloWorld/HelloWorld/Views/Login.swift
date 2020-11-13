//
//  Login.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Login: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var showRegistration = false
    @State private var showAlert = false
    @State private var errorMessage = ""
    @ObservedObject var sessionStore = SessionStore()
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    TextField("email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("password", text: $password)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                                
                Button(action: {
                    sessionStore.signIn(email: email, password: password) { success, error  in
                        if !success, error != nil {
                            showAlert = true
                            errorMessage = "\(String(describing: error!.localizedDescription))"
                        }
                    }
                }, label: {
                    Text("Login")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(25)
                })
                .padding()
                
                Text("Don't have an account? Sign up")
                    .font(.subheadline)
                    .padding()
                    .onTapGesture {
                        showRegistration.toggle()
                    }
                    .sheet(isPresented: $showRegistration, content: {
                        Register(showRegistration: $showRegistration)
                    })
            }
            .navigationTitle("Welcome")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
