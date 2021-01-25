//
//  ProfileViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/29/20.
//

import SwiftUI
import Firebase
import FirebaseStorage

final class ProfileViewModel: ObservableObject {
  @Published var profilePicture = ""
  @Published var newEmail = ""
  @Published var newPassword = ""
  @Published var passwordCheck = ""
  @Published var showAlert = false
  @Published var showActionSheet = false
  @Published var showImagePicker = false
  @Published var showPictureConfirmation = false
  
  var alert = AlertMessage.passwordChanged
  var errorMessage = ""
  
  private let db = Firestore.firestore()
  private let storage = Storage.storage().reference()
  
  // MARK: - Field Validation
  
  var areFieldsCompleted: Bool {
    Helper.validateForm(for: [newPassword, passwordCheck])
  }
  
  func checkPasswords(completion: () -> Void) {
    if newPassword != passwordCheck {
      alert = .passwordMismatch
      showAlert = true
    } else {
      completion()
    }
  }
  
  // MARK: - Email/Password Change

  enum changeResult {
    case emailChangeSuccess
    case emailChangeFailed(message: String)
    case passwordChangeSuccess
    case passwordChangeFailed(message: String)
  }
  
  func updateInfo(result: changeResult) {
    switch result {
    case .emailChangeSuccess:
      errorMessage = "Email updated to \(newEmail)"
      alert = .emailChanged
      newEmail = ""
    case .passwordChangeSuccess:
      alert = .passwordChanged
      newPassword = ""
      passwordCheck = ""
    case .emailChangeFailed(let message):
      errorMessage = message
      alert = .passwordError
    case .passwordChangeFailed(let message):
      errorMessage = message
      alert = .emailError
    }
    showAlert.toggle()
  }
  
  // MARK: - Profile picture
  
  func fetchProfilePicture() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    db.collection("userprofiles").document(uid).addSnapshotListener { [weak self] (snapshot, error) in
      guard let self = self, error == nil else {
        print("error fetching profile picture")
        return
      }
      if let document = snapshot, let data = document.data() {
        self.profilePicture = data["profilePicture"] as? String ?? ""
      }
    }
  }
  
  func updateProfilePicture(imageData: Data?) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    // User selected image from camera/library
    if imageData != nil {
      // Add image to storage
      storage.child("profilePictures").child(uid).putData(imageData!, metadata: nil) { (_, error) in
        guard error == nil else {
          print("userprofileVM putData error: ", error!.localizedDescription)
          return
        }
        // Get URL for image
        self.storage.child("profilePictures").child(uid).downloadURL { (url, err) in
          guard let url = url, err == nil else {
            print("userprofileVM downloadURL error: ", err!.localizedDescription)
            return
          }
          // Add URL to database
          self.db.collection("userprofiles").document(uid).setData(["profilePicture": url.absoluteString], merge: true)
        }
      }
    } else {
      // User reset to default picture, delete image from storage, set URL in database to blank
      self.storage.child("profilePictures").child(uid).delete { error in
        guard error == nil else {
          print("error deleting picture from storage: ", error!.localizedDescription)
          return
        }
        self.db.collection("userprofiles").document(uid).setData(["profilePicture": ""], merge: true)
      }
    }
  }
  
//  deinit {
//    print("deint profileVM")
//  }
}

// MARK: - Alert Management

extension ProfileViewModel {
  
  enum AlertMessage {
    case passwordChanged, passwordMismatch ,emailChanged, passwordError, emailError
  }
  
  func getAlert() -> Alert {
    switch alert {
    case .passwordChanged:
      return Alert(
        title: Text("Password has been successfully changed"),
        dismissButton: .default(Text("OK")))
    case .emailChanged:
      return Alert(
        title: Text("Email has been successfully changed"),
        message: Text(errorMessage),
        dismissButton: .default(Text("OK")))
    case .passwordError:
      return Alert(
        title: Text("Password could not be changed"),
        message: Text(errorMessage),
        dismissButton: .default(Text("OK")))
    case .passwordMismatch:
      return Alert(
        title: Text("Password could not be changed"),
        message: Text("Passwords do not match, please try again"),
        dismissButton: .default(Text("OK")))
    case .emailError:
      return Alert(
        title: Text("Email could not be changed"),
        message: Text(errorMessage),
        dismissButton: .default(Text("OK")))
    }
  }
}
