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
    @State var alert = false
    @State var isLoading = false
    
    // TODO: form validation (min characters, no empty fields/spaces)
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var sessionStore = SessionStore()
    @ObservedObject var userProfile = UserProfileViewModel()
    
    var body: some View {
    
        NavigationView {
            ZStack {
                VStack {
                    Group {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("email", text: $email)
                        SecureField("password", text: $password)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        
                        isLoading.toggle()
                        
                        sessionStore.signUp(email: email, password: password) {
                            
                            userProfile.createProfile(firstName: firstName, lastName: lastName, email: email)
                            
                            self.presentationMode.wrappedValue.dismiss()
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
                    LoadingAnimation()
                        .frame(width: 200, height: 200)
                }
            }
        }
        
        //        .alert(isPresented: $alert) {
        //            Alert(title: Text("Alert"), message: Text("Message"), dismissButton: .default(Text("OK")))
        //        }
    }
}


//struct Register_Previews: PreviewProvider {
//    static var previews: some View {
//        Register()
//    }
//}
