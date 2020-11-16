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
    var date = Date()
}

class MessagesViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var lastMessage = [Message]().last
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
                        let timestamp = data["sentAt"] as? Timestamp ?? Timestamp()

                        return Message(id: docId, content: content, name: displayName, email: safeEmail, profilePicture: picture, date: timestamp.dateValue())
                    }
                    
                    self.lastMessage = self.messages.last
                }
        }
    }
    
    func timeSinceMessage(message: Date) -> String  {
        let dateFormatter = DateFormatter()
        let relDateFormatter = RelativeDateTimeFormatter()
        relDateFormatter.unitsStyle = .short

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.minute], from: message, to: Date())

        guard let minute = dateComponents.minute
        else {
            return ("error getting hour")
        }
        // greater than 6 days (>8640 mins), show date
        if Int(minute) > 8640 {
            dateFormatter.dateFormat = "MMM d, h:mm a"
            return dateFormatter.string(from: message)
            
        // greater than 2 hours (> 120 mins), show day of the week
        } else if Int(minute) > 120 {
            dateFormatter.dateFormat = "E h:mm a"
            return dateFormatter.string(from: message)
        } else {
            
            // less than 2 hours, use relative time
            return relDateFormatter.string(for: message) ?? "error formatting date"
        }
    }
}
