//
//  Register.swift
//  HelloWorld
//
//  Created by Larry N on 11/5/20.
//

import SwiftUI

struct Register: View {
    
    @State var email = ""
    @State var password = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var showAlert = false
    @State var isLoading = true
    
    // TODO: form validation (min characters, no empty fields/spaces)
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var sessionStore = SessionStore()
    @ObservedObject var userProfile = UserProfileViewModel()
    
    var body: some View {
    
        NavigationView {
            ZStack {
                VStack {
                    
                    // TODO: add logo
                    
                    Group {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("email", text: $email)
                        SecureField("password", text: $password)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        
                        isLoading.toggle()
                        
                        sessionStore.signUp(email: email, password: password) { success in
                            if success {
                                userProfile.createProfile(firstName: firstName, lastName: lastName, email: email)
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                showAlert = true
                                isLoading.toggle()
                            }
                        }
                        
                    }, label: {
                        Text("Sign up")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    })
                    .padding()
                    
                    Spacer()

                }
                .padding()
                .navigationTitle("Welcome")
                
                if isLoading {
                    Loading()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text("You done goofed"), dismissButton: .default(Text("OK")))
        }
    }
}


//struct Register_Previews: PreviewProvider {
//    static var previews: some View {
//        Register()
//    }
//}
