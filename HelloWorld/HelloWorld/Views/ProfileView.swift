//
//  ProfileView.swift
//  HelloWorld
//
//  Created by Larry N on 11/16/20.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @StateObject var profileVM = ProfileViewModel()
    @State private var inputImage: UIImage?
    @State private var newPhoto: Image?
            
    func loadImage() {
        guard let inputImage = inputImage else { return }
        newPhoto = Image(uiImage: inputImage)
    }
    
    var body: some View {
        ZStack {
            Constants.gradientBackground
                .edgesIgnoringSafeArea(.all)
                .zIndex(-99)
            
            VStack {
                HStack {
                    Text("hello, \(sessionStore.userName?.lowercased() ?? "there")")
                        .foregroundColor(Constants.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding([.top, .horizontal])
                .onAppear {
                    sessionStore.fetchUser()
                }
                
                HStack(spacing: 50) {
                    ZStack(alignment: .bottomTrailing) {
                        ProfilePictureView(image: newPhoto, photoURL: profileVM.profilePicture)
                            .padding(.vertical, 15)
                            .onAppear {
                                profileVM.fetchProfilePicture()
                            }
                        
                        Button(action: {
                            profileVM.showActionSheet = true
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Constants.title)
                                .background(Constants.primary)
                                .clipShape(Circle())
                                .offset(x: -4, y: -4)
                        }
                    }
                    
                    // allow user to apply/cancel picture change
                    if profileVM.showPictureConfirmation {
                        VStack {
                            
                            // apply changes
                            Button(action: {
                                withAnimation {
                                    profileVM.showPictureConfirmation.toggle()
                                }
                                if let data = inputImage?.jpegData(compressionQuality: 0.45) {
                                    ProfileViewModel().updateProfilePicture(imageData: data)
                                }
                            }) {
                                Text("apply")
                                    .padding()
                                    .frame(width: 100)
                                    .foregroundColor(Constants.title)
                                    .background(Constants.primary)
                                    .shadowStyle()
                            }
                            
                            // discard changes
                            Button(action: {
                                withAnimation {
                                    profileVM.showPictureConfirmation.toggle()
                                }
                                newPhoto = nil
                                
                            }) {
                                Text("cancel")
                                    .padding()
                                    .frame(width: 100)
                                    .foregroundColor(Constants.title)
                                    .background(Constants.primary)
                                    .shadowStyle()
                            }
                        }
                        .transition(.move(edge: .trailing))
                    }
                }
                
                // MARK:  change password
                VStack(alignment: .leading, spacing: 10) {
                    Text("change password")
                        .foregroundColor(Constants.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Group {
                        HStack(spacing: 15) {
                            Image(systemName: "lock.fill")
                                .frame(width:20)
                            SecureField("password", text: $profileVM.newPassword)
                                .textContentType(.newPassword)
                                .keyboardType(.default)
                        }
                        
                        HStack(spacing: 15) {
                            Image(systemName: "lock.fill")
                                .frame(width:20)
                            SecureField("retype password", text: $profileVM.passwordCheck)
                                .textContentType(.newPassword)
                                .keyboardType(.default)
                            
                            Text("apply")
                                .foregroundColor(profileVM.areFieldsCompleted ? .green : Color(.gray).opacity(0.5))
                                .onTapGesture {
                                    profileVM.checkPasswords {
                                        sessionStore.updatePassword(to: profileVM.newPassword) { (error) in
                                            if error == nil {
                                                profileVM.alert = .passwordChanged
                                                profileVM.showAlert.toggle()
                                            } else {
                                                profileVM.errorMessage = error?.localizedDescription ?? "Please try again"
                                                profileVM.alert = .passwordError
                                                profileVM.showAlert.toggle()
                                            }
                                        }
                                    }
                                }
                                .disabled(!profileVM.areFieldsCompleted)
                        }
                    }
                    .padding()
                    .background(Constants.fill)
                    .shadowStyle()
                    
                    // MARK:  change email
                    Text("change email")
                        .foregroundColor(Constants.title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    
                    HStack(spacing: 15) {
                        Image(systemName: "envelope.fill")
                            .frame(width:20)
                        TextField("email", text: $profileVM.newEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Text("apply")
                            .foregroundColor(!profileVM.newEmail.isEmpty ? .green : Color(.gray).opacity(0.5))
                            .onTapGesture {
                                sessionStore.updateEmail(to: profileVM.newEmail) { (error) in
                                    if error == nil {
                                        profileVM.alert = .emailChanged
                                        profileVM.showAlert.toggle()
                                    } else {
                                        profileVM.errorMessage = error?.localizedDescription ?? "Please try again"
                                        profileVM.alert = .emailError
                                        profileVM.showAlert.toggle()
                                    }
                                }
                            }
                            .disabled(profileVM.newEmail.isEmpty)
                    }
                    .padding()
                    .background(Constants.fill)
                    .shadowStyle()
                }
                .padding()
                
                Spacer()
                
                // MARK:  sign out
                Button(action: {
                    sessionStore.signOut()
                }) {
                    Text("sign out")
                        .buttonStyle(condition: true)
                }
                Spacer()
            }
        }
        .actionSheet(isPresented: $profileVM.showActionSheet) {
            ActionSheet(
                title: Text("Change profile picture"),
                message: Text("Your photo will appear next to your messages and will be visible to others"),
                buttons: [
                    .default(Text("Camera")) {  },
                    .default(Text("Photo library")) {
                        profileVM.showImagePicker.toggle()
                        withAnimation {
                            profileVM.showPictureConfirmation.toggle()
                        }
                    },
                    .default(Text("Reset to default photo")) {
                        newPhoto = nil
                        profileVM.updateProfilePicture(imageData: nil)
                    },
                    .cancel()
                ])
        }
        .sheet(isPresented: $profileVM.showImagePicker, onDismiss: { loadImage() }) {
            ImagePicker(image: $inputImage)
        }
        .alert(isPresented: $profileVM.showAlert) {
            profileVM.getAlert()
        }
    }
}

struct ProfileSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct ProfilePictureView: View {
    var image: Image?
    var photoURL: String
    
    var body: some View {
        Group {
            // user changed image
            if image != nil {
                image?
                    .resizable()
                    .imageStyle()
                
            // user has profile picture
            } else if photoURL != "" {
                WebImage(url: URL(string: photoURL))
                    .resizable()
                    .placeholder {
                        Circle().foregroundColor(Constants.primary)
                    }
                    .imageStyle()
                
            // user has not set profile picture
            } else {
                Image("DefaultProfilePicture")
                    .resizable()
                    .imageStyle()
            }
        }
    }
}
