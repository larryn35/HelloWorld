//
//  ProfileSettings.swift
//  HelloWorld
//
//  Created by Larry N on 11/16/20.
//

import SwiftUI
import FirebaseAuth

struct ProfileSettings: View {
    
    @State private var imageData : Data = .init(count: 0)
    @State private var showImagePicker = false
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var passwordCheck = ""
    @State private var showAlert = false
    @State private var showActionSheet = false
    @State private var errorMessage = ""
    
    @ObservedObject var sessionStore = SessionStore()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                .zIndex(-99)
            
            VStack {
                HStack {
                    Text("Hello, \(Auth.auth().currentUser?.displayName ?? "there!")")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                
                
                ZStack(alignment: .bottomTrailing) {
                    
                    Group {
                        if self.imageData.count == 0 {
                            Image("DefaultProfilePicture")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .shadow(radius: 15)
                                .overlay(Circle().stroke(Color.white, lineWidth: 8))
                                .frame(width: 150, height: 150)
                        } else {
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
                    }
                    .padding(.vertical, 30)
                    
                    
                    Button(action: {
                        showActionSheet = true
                        
                    }, label: {
                        Image(systemName: "camera.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .background(Color(.blue))
                            .clipShape(Circle())
                            .offset(x: -4, y: -4)
                    })
                }
                
                Form {
                    Section(header: Text("change password").padding(.top)) {
                        SecureField("password", text: $newPassword)
                            .textContentType(.newPassword)
                            .keyboardType(.default)

                        SecureField("retype password", text: $passwordCheck)
                            .textContentType(.newPassword)
                            .keyboardType(.default)
                        
                        Button(action: {
                            if newPassword != passwordCheck {
                                showAlert = true
                                errorMessage = "passwords do not match, please try again"
                                
                            } else {
                                sessionStore.updatePassword(to: newPassword) { success, error in
                                    if success, error == nil {
                                        newPassword = ""
                                    } else {
                                        showAlert = true
                                        errorMessage = "\(String(describing: error!.localizedDescription))"
                                    }
                                }
                            }
                        }, label: {
                            Text("apply")
                        })
                    }
                    
                    Section(header: Text("change email").padding(.top)) {
                        TextField("email", text: $newEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        Button(action: {
                            sessionStore.updateEmail(to: newEmail) { success, error in
                                if success, error == nil {
                                    newEmail = ""
                                } else {
                                    showAlert = true
                                    errorMessage = "\(String(describing: error!.localizedDescription))"
                                }
                            }
                        }, label: {
                                Text("apply")
                        })
                    }
                }
                .background(Color(.white).opacity(0.7))
                .frame(height: 360)
                .cornerRadius(10)
                .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
                .padding()
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                }
                
                Spacer()
                
                Button(action: {
                    sessionStore.signOut()
                }, label: {
                    Text("sign out")
                        .padding(8)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
                })
                
                Spacer()
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Change background"), message: Text("Select a new color"), buttons: [
                .default(Text("Camera")) {  },
                .default(Text("Photo library")) { showImagePicker = true },
                .default(Text("Reset to default photo")) { imageData.count = 0 },
                .cancel()
            ])
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageData: $imageData)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("uh-oh"), message: Text(errorMessage), dismissButton: .default(Text("ok")))
        }
    }
}

struct ProfileSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettings()
    }
}
