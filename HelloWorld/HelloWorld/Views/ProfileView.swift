//
//  ProfileView.swift
//  HelloWorld
//
//  Created by Larry N on 11/16/20.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
  @EnvironmentObject var sessionStore: SessionStore
  @StateObject var profileVM = ProfileViewModel()
  @State private var inputImage: UIImage?
  @State private var newPhoto: Image?
  @State private var keyboardDisplayed = false
  @State private var shouldShowCamera = false
  
  func loadImage() {
    guard let inputImage = inputImage else { return }
    newPhoto = Image(uiImage: inputImage)
  }
  
  var body: some View {
    ZStack {
      Constants.primary
        .edgesIgnoringSafeArea(.all)
        .zIndex(-99)
        .onTapGesture {
          withAnimation {
            hideKeyboard()
            keyboardDisplayed = false
          }
        }
      
      VStack {
        if !keyboardDisplayed {
          HStack {
            Text("hello, \(sessionStore.userName?.lowercased() ?? "there")")
              .foregroundColor(Constants.textColor)
              .font(.title)
              .fontWeight(.semibold)
            
            Spacer()
          }
          .padding([.top, .horizontal])
          .onAppear {
            sessionStore.fetchUser()
          }
        }
        
        // MARK:  - Display/change profile picture
        
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
                .foregroundColor(Constants.textColor)
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
                  .foregroundColor(Constants.textColor)
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
                  .foregroundColor(Constants.textColor)
                  .background(Constants.primary)
                  .shadowStyle()
              }
            }
            .transition(.move(edge: .trailing))
          }
        }
        
        // MARK:  - Change password
        
        VStack(alignment: .leading, spacing: 10) {
          Text("change password")
            .foregroundColor(Constants.textColor)
            .font(.title)
            .fontWeight(.semibold)
          
          TextFieldView(type: .password, placeholder: "new password", image: "lock.fill", binding: $profileVM.newPassword)
          
          HStack {
            TextFieldView(type: .password, placeholder: "retype password", image: "lock.fill", binding: $profileVM.passwordCheck)
            
            if profileVM.areFieldsCompleted {
              Text("apply")
                .onTapGesture {
                  profileVM.checkPasswords {
                    sessionStore.updatePassword(to: profileVM.newPassword) { (error) in
                      if error == nil {
                        profileVM.alert = .passwordChanged
                        profileVM.showAlert.toggle()
                        profileVM.newPassword = ""
                        profileVM.passwordCheck = ""
                      } else {
                        profileVM.errorMessage = error?.localizedDescription ?? "Please try again"
                        profileVM.alert = .passwordError
                        profileVM.showAlert.toggle()
                      }
                    }
                  }
                }
                .padding()
                .foregroundColor(.red)
                .background(Constants.textFieldColor)
                .shadowStyle()
            }
          }
          
          // MARK: - Change email
          
          Text("change email")
            .foregroundColor(Constants.textColor)
            .font(.title)
            .fontWeight(.semibold)
            .padding(.top, 10)
          
          HStack {
            TextFieldView(type: .email, placeholder: "email", image: "envelope.fill", binding: $profileVM.newEmail)
            
            if !profileVM.newEmail.isEmpty {
              Text("apply")
                .onTapGesture {
                  sessionStore.updateEmail(to: profileVM.newEmail) { (error) in
                    if error == nil {
                      profileVM.errorMessage = "Email updated to \(profileVM.newEmail)"
                      profileVM.alert = .emailChanged
                      profileVM.showAlert.toggle()
                      profileVM.newEmail = ""
                    } else {
                      profileVM.errorMessage = error?.localizedDescription ?? "Please try again"
                      profileVM.alert = .emailError
                      profileVM.showAlert.toggle()
                    }
                  }
                }
                .padding()
                .foregroundColor(.red)
                .background(Constants.textFieldColor)
                .shadowStyle()
            }
          }
        }
        .padding()
        
        Spacer()
        
        // MARK: - Sign out
        
        Button(action: {
          sessionStore.signOut()
        }) {
          Text("sign out")
        }
        .buttonStyle(PrimaryButtonStyle(condition: true))
        
        Spacer()
      }
    }
    .actionSheet(isPresented: $profileVM.showActionSheet) {
      actionSheet
    }
    .sheet(isPresented: $profileVM.showImagePicker, onDismiss: { loadImage() }) {
      ImagePicker(image: $inputImage, sourceType: shouldShowCamera ? .camera : .photoLibrary)
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

extension ProfileView {
  var actionSheet: ActionSheet {
    ActionSheet(
      title: Text("Change profile picture"),
      message: Text("Your photo will appear next to your messages and will be visible to others"),
      buttons: [
        .default(Text("Camera")) {
          shouldShowCamera = true
          profileVM.showImagePicker.toggle()
          withAnimation {
            profileVM.showPictureConfirmation = true
          }
        },
        .default(Text("Photo library")) {
          shouldShowCamera = false
          profileVM.showImagePicker.toggle()
          withAnimation {
            profileVM.showPictureConfirmation = true
          }
        },
        .default(Text("Reset to default photo")) {
          newPhoto = nil
          profileVM.updateProfilePicture(imageData: nil)
          profileVM.showPictureConfirmation = false
        },
        .cancel()
      ])
  }
}
