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
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let safeEmail = email.lowercased()
        authRef.signIn(withEmail: safeEmail, password: password) { (result, error) in
            guard result != nil, error == nil else {
                print("failed to sign in with \(email)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let safeEmail = email.lowercased()
        authRef.createUser(withEmail: safeEmail, password: password)
        { (result, error) in
            guard result != nil, error == nil else {
                print("Error signing up with \(email): \(String(describing: error))")
                completion(false)
                return
            }
            print("Signed up with \(email)")
            completion(true)
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
    
    // unmounts authentication state listener, prevents listener from running in the background after unmounting iew
    func unbind() {
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
}
