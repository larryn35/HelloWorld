//
//  LoginView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @StateObject var loginVM = LoginViewModel()
    @Binding var keyboardDisplayed: Bool
        
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "envelope")
                    .frame(width:20)
                
                TextField("email", text: $loginVM.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onTapGesture {
                        keyboardDisplayed = true
                    }
            }
            .padding()
            
            Divider()
            
            HStack(spacing: 15) {
                Image(systemName: "lock")
                    .frame(width:20)
                
                SecureField("password", text: $loginVM.password)
                    .onTapGesture {
                        keyboardDisplayed = true
                    }
            }
            .padding([.horizontal, .top])
            
            Button(action: {
                sessionStore.signIn(email: loginVM.email, password: loginVM.password) {
                    loginVM.clearFields()
                }
            }) {
                Text("sign in")
            }
            .buttonStyle(PrimaryButtonStyle(condition: loginVM.isFormCompleted))
            .disabled(!loginVM.isFormCompleted)
            
        }
        .frame(width: Constants.contentWidth)
        .background(
            Constants.fill.shadowStyle()
        )
        .alert(isPresented: $sessionStore.showAlert) {
            Alert(title: Text("Please try again"),
                  message: Text(sessionStore.errorMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct Login_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView(keyboardDisplayed: .constant(false)).environmentObject(SessionStore())
    }
}
