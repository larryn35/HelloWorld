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
    
    // MARK:  Validation
    var areFieldsCompleted: Bool {
        Helper.validateForm(for: [newPassword, passwordCheck])
    }
    
    func checkPasswords(completion: () -> Void) {
        if newPassword != passwordCheck {
            alert = .passwordMismatch
            showAlert = true
        } else {
            newPassword = ""
            passwordCheck = ""
            completion()
        }
    }
    
    // MARK:  Alerts
    enum AlertMessage {
        case passwordChanged, passwordMismatch ,emailChanged, passwordError, emailError
    }
    
    func getAlert() -> Alert {
        switch alert {
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
    
    // MARK:  Profile picture
    
    func updateProfilePicture(imageData: Data?) {
        if let uid = Auth.auth().currentUser?.uid {
            
            if imageData != nil {
                // add image to storage
                storage.child("profilePictures").child(uid).putData(imageData!, metadata: nil) { (_, error) in
                    guard error == nil else {
                        print("userprofileVM putData error: ", error!)
                        return
                    }
                    
                    // get URL for image
                    self.storage.child("profilePictures").child(uid).downloadURL { (url, err) in
                        guard let url = url, err == nil else {
                            print("userprofileVM downloadURL error: ", err!)
                            return
                        }
                        
                        // add URL to database
                        self.db.collection("userprofiles").document(uid).setData(["profilePicture": url.absoluteString], merge: true)
                    }
                }
            } else {
                // delete image from storage, set URL in database to blank
                self.storage.child("profilePictures").child(uid).delete { (error) in
                    if error == nil {
                        self.db.collection("userprofiles").document(uid).setData(["profilePicture": ""], merge: true)
                    }
                    print("error deleting picture from storage")
                }
            }
        }
    }
    
    func fetchProfilePicture() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("userprofiles").document(uid).addSnapshotListener { [weak self] (snapshot, error) in
                guard let document = snapshot else {
                    print("no docs returned")
                    return
                }
                
                guard let self = self, let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self.profilePicture = data["profilePicture"] as? String ?? ""
            }
        }
    }
}

