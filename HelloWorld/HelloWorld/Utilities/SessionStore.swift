//
//  SessionStore.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import Foundation
import FirebaseAuth

struct User {
    var uid: String
    var email: String
}

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var isAnon: Bool = false
    var handle: AuthStateDidChangeListenerHandle?
    let authRef = Auth.auth()
    
    // Attaches a listener for Firebase to signal whenever a change to the authentication state occurs
    func listen() {
        handle = authRef.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.isAnon = false
                guard let email = user.email else { return }
                self.session = User(uid: user.uid, email: email)
            } else {
                self.isAnon = true
                self.session = nil
            }
        })
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let safeEmail = email.lowercased()
        authRef.signIn(withEmail: safeEmail, password: password) { (result, error) in
            guard result != nil, error == nil else {
                print("failed to sign in with \(email)")
                completion(false, error)
                return
            }
            completion(true, error)
        }
    }
    
    func signUp(email: String, password: String, displayName: String, completion: @escaping (Bool, Error?) -> Void) {
        let safeEmail = email.lowercased()
        authRef.createUser(withEmail: safeEmail, password: password) { (result, error) in
            guard result != nil, error == nil else {
                print("Error signing up with \(email): \(String(describing: error!.localizedDescription))")
                completion(false, error)
                return
            }
            print("Signed up with \(email)")
            
            // set display name
            if Auth.auth().currentUser != nil {
                self.updateProfile(displayName: displayName)
            }
            
            completion(true, error)
        }
    }
    
    func signOut() {
        do {
            try authRef.signOut()
            session = nil
            isAnon = true
        } catch {
            print("error signing out: \(error)")
        }
    }
    
    func updateProfile(displayName: String?) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print("error updating user profile: \(error.localizedDescription)" )
            } else {
                print("profile updated for \(String(describing: displayName))")
            }
        }
    }
    
    func updateEmail(to email: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if error != nil {
                print("failed to update email: \(String(describing: error?.localizedDescription))")
                completion(false, error)
                return
                
            } else {
                print("email updated to \(email)")
                completion(true, error)
            }
        }
    }
    
    func updatePassword(to password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if error != nil {
                print("failed to update password: \(String(describing: error?.localizedDescription))")
                completion(false, error)
                return
                
            } else {
                print("password updated")
                completion(true, error)
            }
        }
    }
    
    // unmounts authentication state listener, prevents listener from running in the background after unmounting iew
    func unbind() {
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
}
