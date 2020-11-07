//
//  UserProfile.swift
//  HelloWorld
//
//  Created by Larry N on 11/5/20.
//

import Foundation
import Firebase

struct UserProfile: Codable, Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var email: String
}

class UserProfileViewModel: ObservableObject {
    @Published var userProfiles = [UserProfile]()
    private let db = Firestore.firestore()
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
                        return UserProfile(firstName: firstName, lastName: lastName, email: email)
                    })
                }
        }
    }
    
    func createProfile(firstName: String, lastName: String, email: String) {
        db.collection("userprofiles")
            .addDocument(data: [
                "firstName": firstName,
                "lastName": lastName,
                "email": email.lowercased(),
            ]) { error in
                if let error = error {
                    print("error adding profile: \(error)")
                } else {
                    print("successfuly created profile for \(email)")
                }
            }
    }
}

