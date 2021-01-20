//
//  ChatroomsViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Chatroom: Codable, Identifiable, Hashable {
  var id: String
  var title: String
  var joinCode: Int
  var userNames: [String]
}

final class ChatroomsViewModel: ObservableObject {
  @Published var chatrooms = [Chatroom]()
  @Published var newTitle = ""
  @Published var joinCode = ""
  @Published var errorMessage = ""
  
  private let db = Firestore.firestore()
  private let user = Auth.auth().currentUser
  
  // MARK: - Field Validation
  
  var isTitleValid: Bool {
    Helper.validateForm(for: [newTitle])
  }
  
  var isCodeValid: Bool {
    joinCode.count == 4
  }
  
  // MARK: - Chatroom Functions
  
  // Fetch chatrooms that contain user's UID from Firestore
  func fetchChatRoomData() {
    guard let user = user else { return }
    db.collection("chatrooms").whereField("users", arrayContains: user.uid)
      .order(by: "lastMessage", descending: true)
      .addSnapshotListener { [weak self] snapshot, error in
      guard let self = self, error == nil else {
        print("error fetching chatrooms: ", error!.localizedDescription)
        return
      }
      
      if let documents = snapshot?.documents {
        self.chatrooms = documents.map { docSnapshot -> Chatroom in
          let data = docSnapshot.data()
          let docId = docSnapshot.documentID
          let title = data["title"] as? String ?? ""
          let userNames = data["userNames"] as? [String] ?? [""]
          let joinCode = data["joinCode"] as? Int ?? -1
          return Chatroom(id: docId, title: title, joinCode: joinCode, userNames: userNames)
        }
      }
    }
  }
  
  // Create chatroom document with user's title, random joinCode, user's UID, and name
  func createChatroom(completion: @escaping () -> Void) {
    guard let user = user else { return }
    db.collection("chatrooms").addDocument(data: [
      "title": newTitle,
      "joinCode": Int.random(in: 1000..<9999),
      "users": [user.uid],
      "userNames": [user.displayName],
      "lastMessage": Date()
    ]) { [weak self] error in
      guard let self = self, error == nil else {
        print("error creating chatroom document")
        return
      }
      self.newTitle = ""
      completion()
    }
  }
  
  func joinChatroom(code: String, completion: @escaping () -> Void) {
    guard let intCode = Int(code) else {
      print("intCode error")
      return
    }
    
    // Find chatroom with matching joinCode
    db.collection("chatrooms").whereField("joinCode", isEqualTo: intCode).getDocuments { [weak self] (snapshot, error) in
      guard let self = self, error == nil else {
        print("error joining chatroom, cannot get chatroom documents")
        return
      }
      
      if let user = self.user, let name = self.user?.displayName {
        // Add user's UID and username to chatroom
        for document in snapshot!.documents {
          self.db.collection("chatrooms").document(document.documentID).updateData([
            "users": FieldValue.arrayUnion([user.uid]),
            "userNames": FieldValue.arrayUnion([name]),
          ])
          
          // Add user joined message to chatroom
          MessagesViewModel().sendMessage(
            messageContent: "\(name) has joined the chatroom",
            docId: document.documentID,
            senderName: "HelloWorld",
            profilePicture: nil
          )
          
          self.joinCode = "" // Clear joinCode field after joining
          completion()
        }
      }
    }
  }
  
  func leaveChatroom(code: String, completion: @escaping () -> Void) {
    guard let intCode = Int(code) else {
      print("intCode error")
      return
    }
    
    // Find chatroom with matching joinCode
    db.collection("chatrooms").whereField("joinCode", isEqualTo: intCode).getDocuments { [weak self] (snapshot, error) in
      guard let self = self, error == nil else {
        print("error leaving chatroom, cannot get chatroom document")
        return
      }
      
      if let user = self.user, let name = self.user?.displayName {
        // Remove user's UID and username from chatroom
        for document in snapshot!.documents {
          self.db.collection("chatrooms").document(document.documentID).updateData([
            "users": FieldValue.arrayRemove([user.uid]),
            "userNames": FieldValue.arrayRemove([name]),
          ])
          // Add user left message to chatroom
          MessagesViewModel().sendMessage(
            messageContent: "\(name) has left the chatroom",
            docId: document.documentID,
            senderName: "HelloWorld",
            profilePicture: nil
          )
          
          completion()
        }
      }
    }
  }
}
