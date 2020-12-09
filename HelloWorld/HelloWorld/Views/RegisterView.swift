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
    @Binding var keyboardDisplayed: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "person")
                        .frame(width:20)
                    
                    TextField("first name", text: $registerVM.firstName)
                        .onTapGesture {
                            keyboardDisplayed = true
                        }
                }
                .padding()
                
                Divider()
                
                HStack(spacing: 15) {
                    Image(systemName: "person")
                        .frame(width:20)
                    
                    TextField("last name", text: $registerVM.lastName)
                        .onTapGesture {
                            keyboardDisplayed = true
                        }
                }
                .padding()
                
                Divider()
                
                HStack(spacing: 15) {
                    Image(systemName: "envelope")
                        .frame(width:20)
                    
                    TextField("email", text: $registerVM.email)
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
                    
                    SecureField("password (min 6 characters)", text: $registerVM.password)
                        .onTapGesture {
                            keyboardDisplayed = true
                        }
                }
                .padding([.horizontal, .top])
                
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
            .frame(width: Constants.contentWidth)
            .background(
                Constants.fillColor.shadowStyle()
            )
            
            if sessionStore.showAlert {
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
        RegisterView(keyboardDisplayed: .constant(false)).environmentObject(SessionStore())
    }
}
