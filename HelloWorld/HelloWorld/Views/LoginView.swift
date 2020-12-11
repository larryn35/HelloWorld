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
  
  var body: some View {
    ZStack {
      // MARK:  Fields
      VStack {
        VStack(spacing: 0) {
          TextFieldView(
            type: .email,
            placeholder: "email",
            image: "envelope",
            binding: $loginVM.email
          )
          
          Divider()
          
          TextFieldView(
            type: .password,
            placeholder: "password",
            image: "lock",
            binding: $loginVM.password
          )
        }
        .frame(width: Constants.contentWidth)
        .background(Constants.textFieldColor.shadowStyle())
        .padding(.bottom)
        
        // MARK:  Sign-in button
        Button(action: {
          sessionStore.signIn(email: loginVM.email, password: loginVM.password) {
            loginVM.clearFields()
          }
        }) {
          Text("sign in").fontWeight(.bold)
        }
        .buttonStyle(PrimaryButtonStyle(condition: loginVM.isFormCompleted))
        .disabled(!loginVM.isFormCompleted)
      }
      .padding(.vertical)
      
      // MARK:  Loading animation
      if sessionStore.isLoading {
        Loading()
      }
    }
    .alert(isPresented: $sessionStore.showAlert) {
      Alert(title: Text("Please try again"),
            message: Text(sessionStore.errorMessage),
            dismissButton: .default(Text("OK")))
    }
  }
}

struct Login_Previews: PreviewProvider {
  static var previews: some View {
    LoginView().environmentObject(SessionStore())
  }
}
