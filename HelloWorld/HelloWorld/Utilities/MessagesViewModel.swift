//
//  MessagesViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import Foundation
import Firebase

struct Message: Codable, Identifiable, Hashable {
    var id: String?
    var content: String
    var name: String
    var email: String
    var profilePicture: String?
}

class MessagesViewModel: ObservableObject {
    @Published var messages = [Message]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser

    func sendMessage(messageContent: String, docId: String, senderName: String, profilePicture: String?) {
        if (user != nil) {
            // sender did not set profile picture
            if profilePicture != nil {
                guard let user = user, let userEmail = user.email else { return }
                db.collection("chatrooms").document(docId).collection("messages")
                    .addDocument(data: [
                        "sentAt": Date(),
                        "displayName": senderName,
                        "email": userEmail,
                        "content": messageContent,
                        "sender": user.uid,
                        "profilePicture": profilePicture!
                    ]
                    )
                print("user with profile picture sent message")
                
            } else {
                // sender has profile picture
                guard let user = user, let userEmail = user.email else { return }
                db.collection("chatrooms").document(docId).collection("messages")
                    .addDocument(data: [
                        "sentAt": Date(),
                        "displayName": senderName,
                        "email": userEmail,
                        "content": messageContent,
                        "sender": user.uid,
                    ]
                    )
                print("user without profile picture sent message")
            }
            
        } else {
            print("user not found")
        }
    }
    
    func fetchMessages(docId: String) {
        if (user != nil) {
            db.collection("chatrooms").document(docId).collection("messages").order(by: "sentAt", descending: false)
                .addSnapshotListener { (snapshot, error) in
                    guard let documents = snapshot?.documents else {
                        print("no documents")
                        return
                    }
                                                            
                    self.messages = documents.map { docSnapshot -> Message in
                        let data = docSnapshot.data()
                        let docId = docSnapshot.documentID
                        let content = data["content"] as? String ?? ""
                        let displayName = data["displayName"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let safeEmail = email.lowercased()
                        let picture = data["profilePicture"] as? String
                        return Message(id: docId, content: content, name: displayName, email: safeEmail, profilePicture: picture)
                    }
                }
        }
    }
}
