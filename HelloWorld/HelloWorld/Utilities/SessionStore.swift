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

final class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var userName = Auth.auth().currentUser?.displayName
    @Published var isSignedIn: Bool = false
    @Published var isLoading = false
    @Published var showAlert = false
    var errorMessage = ""
    
    var handle: AuthStateDidChangeListenerHandle?
    let authRef = Auth.auth()
    
    func fetchUser() {
        userName = Auth.auth().currentUser?.displayName
    }
    
    // Attaches a listener for Firebase to signal whenever a change to the authentication state occurs
    func listen() {
        handle = authRef.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.isSignedIn = true
                guard let email = user.email else { return }
                self.session = User(uid: user.uid, email: email)
            } else {
                self.isSignedIn = false
                self.session = nil
            }
        })
    }
    
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        let safeEmail = email.lowercased()
        authRef.signIn(withEmail: safeEmail, password: password) { (result, error) in
            guard result != nil, error == nil else {
                print("failed to sign in with \(email)")
                self.errorMessage = error!.localizedDescription
                self.showAlert = true
        
                return
            }
            completion()
        }
    }
    
    func signUp(email: String, password: String, displayName: String, completion: @escaping () -> Void) {
        isLoading.toggle()
        let safeEmail = email.lowercased()
        authRef.createUser(withEmail: safeEmail, password: password) { (result, error) in
            guard result != nil, error == nil else {
                print("Error signing up with \(email): \(String(describing: error!.localizedDescription))")
                self.errorMessage = error!.localizedDescription
                self.isLoading.toggle()
                self.showAlert = true
                
                return
            }
            print("Signed up with \(email)")
            completion()

            // set display name
            if self.authRef.currentUser != nil {
                self.updateProfile(displayName: displayName)
                self.isLoading.toggle()
            }
        }
    }
    
    func signOut() {
        do {
            try authRef.signOut()
            session = nil
            isSignedIn = false
        } catch {
            print("error signing out: \(error)")
        }
    }
    
    func updateProfile(displayName: String) {
        let changeRequest = authRef.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print("error updating user profile: \(error.localizedDescription)" )
            } else {
                print("profile updated for \(String(describing: displayName))")
            }
        }
    }
    
    func updateEmail(to email: String, completion: @escaping (Error?) -> Void) {
        authRef.currentUser?.updateEmail(to: email) { (error) in
            if error != nil {
                print("failed to update email: \(String(describing: error?.localizedDescription))")
                completion(error)
                return
                
            } else {
                print("email updated to \(email)")
                completion(nil)
            }
        }
    }
    
    func updatePassword(to password: String, completion: @escaping (Error?) -> Void) {
        authRef.currentUser?.updatePassword(to: password) { (error) in
            if error != nil {
                print("failed to update password: \(String(describing: error?.localizedDescription))")
                completion(error)
                return
            } else {
                print("password updated")
                completion(nil)
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
