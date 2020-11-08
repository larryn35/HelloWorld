//
//  UserProfile.swift
//  HelloWorld
//
//  Created by Larry N on 11/5/20.
//

import Foundation
import Firebase
import FirebaseStorage

struct UserProfile: Codable, Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var profilePicture: String?
}

class UserProfileViewModel: ObservableObject {
    @Published var userProfiles = [UserProfile]()
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let user = Auth.auth().currentUser
    
    func fetchProfile() {
        if (user != nil) {
            guard let userEmail = user?.email else {
                print("error retrieving userEmail")
                return
            }
            
            db.collection("userprofiles").whereField("email", isEqualTo: userEmail)
                .addSnapshotListener { (snapshot, error) in
                    guard let documents = snapshot?.documents else {
                        print("no docs returned")
                        return
                    }
                    
                    self.userProfiles = documents.map({ (docSnapshot) -> UserProfile in
                        let data = docSnapshot.data()
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let picture = data["profilePicture"] as? String
                        return UserProfile(firstName: firstName, lastName: lastName, email: email, profilePicture: picture)
                    })
                }
        }
    }
    
    func createProfile(firstName: String, lastName: String, email: String, imageData: Data?) {
        
        let uid = Auth.auth().currentUser?.uid
        
        // user added own profile picture
        if imageData != nil {
            storage.child("profilePictures").child(uid!).putData(imageData!, metadata: nil) { (_, error) in
                guard error == nil else {
                    print("userprofileVM putData error: ", error!)
                    return
                }
                self.storage.child("profilePictures").child(uid!).downloadURL { (url, err) in
                    guard let url = url, error == nil else {
                        print("userprofileVM downloadURL error: ", error!)
                        return
                    }
                    
                    self.db.collection("userprofiles")
                        .addDocument(data: [
                            "firstName": firstName,
                            "lastName": lastName,
                            "email": email.lowercased(),
                            "profilePicture": url.absoluteString
                        ]) { error in
                            if let error = error {
                                print("error adding profile: \(error)")
                            } else {
                                print("successfuly created profile with picture for \(email)")
                            }
                        }
                }
            }
            
            // user did not add own profile picture
        } else {
            self.db.collection("userprofiles")
                .addDocument(data: [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email.lowercased(),
                ]) { error in
                    if let error = error {
                        print("error adding profile: \(error)")
                    } else {
                        print("successfuly created profile without picture for \(email)")
                    }
                }
        }
    }
}

