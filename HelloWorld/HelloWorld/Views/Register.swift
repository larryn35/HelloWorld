//
//  Register.swift
//  HelloWorld
//
//  Created by Larry N on 11/5/20.
//

import SwiftUI

struct Register: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var showAlert = false
    @State private var isLoading = false
    @State private var showImagePicker = false
    @State private var imageData : Data = .init(count: 0)
    @Binding var showRegistration : Bool
    
    // TODO: form validation (min characters, no empty fields/spaces)
    
    @ObservedObject var sessionStore = SessionStore()
    @ObservedObject var userProfile = UserProfileViewModel()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    Button(action: {
                        showImagePicker = true
                        self.hideKeyboard()
                        
                    }, label: {
                        if self.imageData.count == 0 {
                            Image("DefaultProfilePicture")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .shadow(radius: 15)
                                .overlay(Circle().stroke(Color.white, lineWidth: 8))
                                .frame(width: 150, height: 150)
                        }
                        else{
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .shadow(radius: 15)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 8))
                                    .frame(width: 150, height: 150)
                            }
                        }
                    })
                    .padding(.vertical, 30)
                    
                    Group {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Create a password (6 characters or longer)", text: $password)
                    }
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        
                        isLoading.toggle()
                        
                        sessionStore.signUp(email: email, password: password) { success in
                            if success {
                                if self.imageData.count == 0 {
                                    userProfile.createProfile(firstName: firstName, lastName: lastName, email: email, imageData: nil)
                                } else {
                                    userProfile.createProfile(firstName: firstName, lastName: lastName, email: email, imageData: imageData)
                                }
                                
                                showRegistration = false
                                
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
                    Spacer()
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(imageData: self.$imageData)
                }
                
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
