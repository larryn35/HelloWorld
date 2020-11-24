//
//  Login.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Login: View {
    @ObservedObject var sessionStore = SessionStore()

    @Binding var keyboardDisplayed: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    private var completedForm: Bool {
        !email.isEmpty && password.count >= 6
    }
        
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "envelope")
                        .frame(width:20)
                    
                    TextField("email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onTapGesture {
                            keyboardDisplayed = true
                        }
                }.padding(.vertical)
                
                Divider()
                
                HStack(spacing: 15) {
                    Image(systemName: "lock")
                        .frame(width:20)
                    
                    SecureField("password", text: $password)
                        .onTapGesture {
                            keyboardDisplayed = true
                        }
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                sessionStore.signIn(email: email, password: password) { success, error  in
                    if !success, error != nil {
                        showAlert = true
                        errorMessage = "\(String(describing: error!.localizedDescription))"
                    }
                }
                
            }, label: {
                Text("sign in")
                    .padding(8)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .foregroundColor(.white)
                    .background(completedForm ? Color.red : Color.gray)
                    .shadowStyle()
            })
            .offset(y: 35)
            .disabled(!completedForm)
        }
        .padding(.vertical)
        .frame(width: UIScreen.main.bounds.width - 50)
        .background(
            Constants.fill.shadowStyle()
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Please try again"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")))
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(keyboardDisplayed: .constant(false))
    }
}
