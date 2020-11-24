//
//  Register.swift
//  HelloWorld
//
//  Created by Larry N on 11/5/20.
//

import SwiftUI

struct Register: View {
    
    @ObservedObject var sessionStore = SessionStore()
    @ObservedObject var userProfile = UserProfileViewModel()
    
    @Binding var keyboardDisplayed: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    private var completedForm: Bool {
        // returns true if all fields are filled
        formValidation(for: [email, password, firstName, lastName])
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                                        
                    HStack(spacing: 15) {
                        Image(systemName: "person")
                            .frame(width:20)
                        TextField("first name", text: $firstName)
                            .onTapGesture {
                                keyboardDisplayed = true
                            }
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    HStack(spacing: 15) {
                        Image(systemName: "person")
                            .frame(width:20)
                        TextField("last name", text: $lastName)
                            .onTapGesture {
                                keyboardDisplayed = true
                            }
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    HStack(spacing: 15) {
                        Image(systemName: "envelope")
                            .frame(width:20)
                        TextField("email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .onTapGesture {
                                keyboardDisplayed = true
                                self.hideKeyboard()
                            }
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    HStack(spacing: 15) {
                        Image(systemName: "lock")
                            .frame(width:20)
                        SecureField("password (min 6 characters)", text: $password)
                            .onTapGesture {
                                keyboardDisplayed = true
                            }
                    }
                    .padding(.vertical)
                    
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    
                    isLoading.toggle()
                    
                    sessionStore.signUp(email: email, password: password, displayName: firstName) { success, error  in
                        if success, error == nil {
                            userProfile.createProfile(firstName: firstName, lastName: lastName, email: email, imageData: nil)
                                                        
                        } else {
                            showAlert = true
                            errorMessage = "\(String(describing: error!.localizedDescription))"
                            isLoading.toggle()
                        }
                    }
                    
                }, label: {
                    Text("sign up")
                        .padding(8)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .foregroundColor(.white)
                        .background(completedForm ? Color.red : Color.gray)
                        .shadowStyle()
                })
                .offset(y: 35)
            }
            .padding(.vertical)
            .background(
                Color(.white).shadowStyle()
            )
            .frame(width: UIScreen.main.bounds.width - 50)
            
            if isLoading {
                Loading()
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Please try again"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}


struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register(keyboardDisplayed: .constant(false))
    }
}

func formValidation(for strings: [String]) -> Bool {
    var passes = [Bool]()
    for string in strings {
        // field does not pass validation (false) if is empty / contains just spaces
        passes.append(!string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    
    // if any of the fields fail, return false, otherwise true
    if passes.contains(false) {
        return false
    } else {
        return true
    }
}
