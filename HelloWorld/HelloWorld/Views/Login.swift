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
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    @ObservedObject var sessionStore = SessionStore()
    
    private var completedForm: Bool {
        !email.isEmpty && password.count >= 6
    }
    
    @Binding var keyboardDisplayed: Bool
    
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
                
//                keyboardDisplayed = false
//                self.hideKeyboard()
                
            }, label: {
                Text("sign in")
                    .padding(8)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .foregroundColor(.white)
                    .background(completedForm ? Color.red : Color.gray)
                    .cornerRadius(10)
                    .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
            })
            .offset(y: 35)
            .disabled(!completedForm)
        }
        .padding(.vertical)
        .background(Color(.white).opacity(0.7).cornerRadius(10).shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4))
        .frame(width: UIScreen.main.bounds.width - 50)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Please try again"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(keyboardDisplayed: .constant(false))
    }
}
