//
//  ProfileSettings.swift
//  HelloWorld
//
//  Created by Larry N on 11/16/20.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ProfileSettings: View {
    
    @ObservedObject var sessionStore = SessionStore()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var passwordCheck = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var alert = AlertMessage.passwordChanged
        
    var body: some View {
        ZStack {
            Constants.gradientBackground
                .edgesIgnoringSafeArea(.all)
                .zIndex(-99)
            
            VStack {
                HStack {
                    Text("hello, \(Auth.auth().currentUser?.displayName?.lowercased() ?? "there!")")
                        .foregroundColor(Constants.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding([.top, .horizontal])
                
                ZStack(alignment: .bottomTrailing) {
                    
                    Group {
                        if let profilePicture = userProfileVM.userProfilePicture, profilePicture != "" {
                            WebImage(url: URL(string: profilePicture))
                                .resizable()
                                .placeholder {
                                    Circle().foregroundColor(Constants.primary)
                                }
                                .imageStyle()
                                
                        } else {
                            Image("DefaultProfilePicture")
                                .resizable()
                                .imageStyle()
                        }
                    }
                    .padding(.vertical, 15)
                    
                    Button(action: {
                        showActionSheet = true
                        
                    }, label: {
                        Image(systemName: "camera.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Constants.primary)
                            .background(Constants.title)
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
                                alert = AlertMessage.passwordMismatch
                                showAlert = true
                                
                            } else {
                                sessionStore.updatePassword(to: newPassword) { success, error in
                                    if success, error == nil {
                                        newPassword = ""
                                        alert = AlertMessage.passwordChanged
                                        showAlert = true
                                    } else {
                                        errorMessage = error?.localizedDescription ?? "Please try again"
                                        alert = AlertMessage.passwordError
                                        showAlert = true
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
                                    alert = AlertMessage.emailChanged
                                    showAlert = true
                                } else {
                                    errorMessage = error?.localizedDescription ?? "Please try again"
                                    alert = AlertMessage.emailError
                                    showAlert = true
                                }
                            }
                        }, label: {
                            Text("apply")
                        })
                    }
                }
                .background(Color(.white))
                .frame(height: 360)
                .shadowStyle()
                .padding()
                
                Spacer()
                
                Button(action: {
                    sessionStore.signOut()
                }, label: {
                    Text("sign out")
                        .padding(8)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .shadowStyle()
                })
                
                Spacer()
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Change profile picture"),
                message: Text("Your photo will appear next to your messages and will be visible to others"),
                buttons: [
                    .default(Text("Camera")) {  },
                    .default(Text("Photo library")) { showImagePicker = true },
                    .default(Text("Reset to default photo")) {
                        UserProfileViewModel().updateProfilePicture(imageData: nil)
                    },
                    .cancel()
                ])
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker()
        }
        .alert(isPresented: $showAlert) {
            getAlert(alertType: alert, errorMessage: errorMessage)
        }
    }
}

struct ProfileSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettings()
    }
}

// MARK:  Alert messages

extension ProfileSettings {
    
    enum AlertMessage {
        case passwordChanged, passwordMismatch ,emailChanged, passwordError, emailError
    }
    
    private func getAlert(alertType: AlertMessage, errorMessage: String?) -> Alert {
        switch alertType {
        case .passwordChanged:
            return Alert(
                title: Text("Password has been successfuly changed"),
                dismissButton: .default(Text("OK")))
        case .emailChanged:
            return Alert(
                title: Text("Email has been successfuly changed"),
                dismissButton: .default(Text("OK")))
        case .passwordError:
            return Alert(
                title: Text("Password could not be changed"),
                message: Text(errorMessage ?? "Please try again"),
                dismissButton: .default(Text("OK")))
        case .passwordMismatch:
            return Alert(
                title: Text("Password could not be changed"),
                message: Text("Passwords do not match, please try again"),
                dismissButton: .default(Text("OK")))
        case .emailError:
            return Alert(
                title: Text("Email could not be changed"),
                message: Text(errorMessage ?? "Please try again"),
                dismissButton: .default(Text("OK")))
        }
    }
}



