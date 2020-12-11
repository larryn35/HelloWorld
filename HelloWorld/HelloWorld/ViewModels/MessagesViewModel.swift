//
//  MessagesViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Message: Codable, Identifiable, Hashable {
  var id: String?
  var content: String
  var name: String
  var email: String
  var profilePicture: String?
  var senderID: String
  var date = Date()
}

final class MessagesViewModel: ObservableObject {
  @Published var messages = [Message]()
  @Published var lastMessage = [Message]().last
  @Published var messageCount = 0
  @Published var readMessagesCount = 0
  @Published var messageField = ""
  @Published var showPopover = false
  @Published var showAlert = false
  
  private let db = Firestore.firestore()
  private let user = Auth.auth().currentUser
  
  // MARK:  - Message Functions
  
  // Fetch messages for chatroom with docId from Firestore
  func fetchMessages(docId: String) {
    guard user != nil else { return }
    db.collection("chatrooms").document(docId).collection("messages")
      .order(by: "sentAt", descending: false)
      .addSnapshotListener { [weak self] (snapshot, error) in
        guard let self = self, let documents = snapshot?.documents else {
          print("no message documents returned")
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
          let senderID = data["sender"] as? String  ?? ""
          let timestamp = data["sentAt"] as? Timestamp ?? Timestamp()
          
          return Message(
            id: docId,
            content: content,
            name: displayName,
            email: safeEmail,
            profilePicture: picture,
            senderID: senderID,
            date: timestamp.dateValue())
        }
        
        // Find last message and number of messages in chatroom
        self.lastMessage = self.messages.last
        self.messageCount = self.messages.count
      }
  }
  
  func sendMessage(messageContent: String, docId: String, senderName: String, profilePicture: String?) {
    guard let user = user, let userEmail = user.email else { return }
    // Sender has profile picture
    if let profilePicture = profilePicture {
      db.collection("chatrooms").document(docId).collection("messages").addDocument(data: [
        "sentAt": Date(),
        "displayName": senderName,
        "email": userEmail,
        "content": messageContent,
        "sender": user.uid,
        "profilePicture": profilePicture,
      ])
    } else {
      // Sender has not set own profile picture
      db.collection("chatrooms").document(docId).collection("messages").addDocument(data: [
        "sentAt": Date(),
        "displayName": senderName,
        "email": userEmail,
        "content": messageContent,
        "sender": user.uid,
      ])
    }
    // Update number of messages in chatroom after sending message
    messageCount = messages.count
  }
  
  // User opened chatroom, record number of messages at this moment (treat as read) in Firestore
  func openedMessage(docId: String) {
    guard let user = user else { return }
    fetchMessages(docId: docId)
    db.collection("chatrooms").document(docId).collection("unread").document(user.uid).setData(["messagesRead": messageCount])
  }
  
  func fetchNumberOfReadMessages(docId: String) {
    guard let user = user else { return }
    db.collection("chatrooms").document(docId).collection("unread").document(user.uid)
      .addSnapshotListener { [weak self] (snapshot, error) in
        guard let document = snapshot else { return }
        
        if let self = self, let data = document.data() {
          self.readMessagesCount = data["messagesRead"] as? Int ?? 0
        }
      }
  }
  
  // MARK:  - Date formatter for messages
  
  func timeSinceMessage(message: Date) -> String {
    let dateFormatter = DateFormatter()
    let relDateFormatter = RelativeDateTimeFormatter()
    relDateFormatter.unitsStyle = .short
    
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([Calendar.Component.minute], from: message, to: Date())
    
    guard let minute = dateComponents.minute else { return ("error getting hour") }
    
    // Message sent more than 6 days (>8640 mins) ago, show date
    if Int(minute) > 8640 {
      dateFormatter.dateFormat = "MMM d, h:mm a"
      return dateFormatter.string(from: message)
      
      // More than 2 hours (> 120 mins) ago, show day of the week
    } else if Int(minute) > 120 {
      dateFormatter.dateFormat = "E h:mm a"
      return dateFormatter.string(from: message)
      
      // Sent less than 2 hours, but more than 1 minute ago, use relative time
    } else if Int(minute) > 1 {
      return relDateFormatter.string(for: message) ?? "error formatting date"
      
      // Less than a minute, show "just now"
    } else {
      return "just now"
    }
  }
  
  // MARK:  - Color ID for other users in message
  
  func userColor(for user: String, from users: [String]) -> Color {
    var color = Color.red
    
    switch user {
    case users[0]:
      color = Constants.red
    case users[1]:
      color = Constants.orange
    case users[2]:
      color = Constants.green
    case users[3]:
      color = Constants.teal
    case users[4]:
      color = Constants.blue
    case users[5]:
      color = Constants.purple
    default:
      color = Constants.gray
    }
    
    return color
  }
}
