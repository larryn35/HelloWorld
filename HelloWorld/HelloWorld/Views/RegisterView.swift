//
//  RegisterView.swift
//  HelloWorld
//
//  Created by Larry N on 11/5/20.
//

import SwiftUI

struct RegisterView: View {
  @EnvironmentObject var sessionStore: SessionStore
  @StateObject var registerVM = RegisterViewModel()
  
  var body: some View {
    ZStack {
      // MARK:  Fields
      VStack {
        VStack(spacing: 0) {
          TextFieldView(
            type: .name,
            placeholder: "first name",
            image: "person",
            binding: $registerVM.firstName
          )
          
          Divider()
          
          TextFieldView(
            type: .name,
            placeholder: "last name",
            image: "person",
            binding: $registerVM.lastName
          )
          
          Divider()
          
          TextFieldView(
            type: .email,
            placeholder: "email",
            image: "envelope",
            binding: $registerVM.email
          )
          
          Divider()
          
          TextFieldView(
            type: .password,
            placeholder: "password (min 6 characters)",
            image: "lock",
            binding: $registerVM.password
          )
        }
        .frame(width: Constants.contentWidth)
        .background(Constants.textFieldColor.shadowStyle())
        .padding(.bottom)
        
        // MARK:  Register button
        Button(action: {
          sessionStore.signUp(
            email: registerVM.email,
            password: registerVM.password,
            displayName: "\(registerVM.firstName) \(registerVM.lastName)"
          ) {
            registerVM.clearFields()
          }
        }) {
          Text("sign up").fontWeight(.bold)
          
        }
        .buttonStyle(PrimaryButtonStyle(condition: registerVM.isFormCompleted))
        .disabled(!registerVM.isFormCompleted)
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

struct Register_Previews: PreviewProvider {
  static var previews: some View {
    RegisterView().environmentObject(SessionStore())
  }
}
