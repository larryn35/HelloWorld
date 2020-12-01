//
//  ChatroomsViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Chatroom: Codable, Identifiable {
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
    
    init() {
        fetchChatRoomData()
    }
    
    // MARK:  Validation
    var isTitleValid: Bool {
        Helper.validateForm(for: [newTitle])
    }
    
    var isCodeValid: Bool {
        joinCode.count == 4
    }
    
    func fetchChatRoomData() {
        if (user != nil) {
            db.collection("chatrooms").whereField("users", arrayContains: user!.uid)
                .addSnapshotListener { (snapshot, error) in
                    guard let documents = snapshot?.documents else {
                        print("no docs returned")
                        return
                    }
                    
                    self.chatrooms = documents.map({ (docSnapshot) -> Chatroom in
                        let data = docSnapshot.data()
                        let docId = docSnapshot.documentID
                        let title = data["title"] as? String ?? ""
                        let userNames = data["userNames"] as? [String] ?? [""]
                        let joinCode = data["joinCode"] as? Int ?? -1
                        return Chatroom(id: docId, title: title, joinCode: joinCode, userNames: userNames)
                    })
                }
        }
    }
    
    func createChatroom(completion: @escaping () -> Void) {
        if user != nil {
            db.collection("chatrooms")
                .addDocument(data: [
                    "title": newTitle,
                    "joinCode": Int.random(in: 1000..<9999),
                    "users": [user!.uid],
                    "userNames": [user?.displayName]
                ]) { [weak self] error in
                    if let error = error {
                        print("error adding document: \(error)")
                    } else {
                        self?.newTitle = ""
                        completion()
                    }
                }
        }
    }
    
    func joinChatroom(code: String, completion: @escaping () -> Void) {
        if user != nil {
            guard let intCode = Int(code) else {
                print("intCode error")
                return
            }
            db.collection("chatrooms").whereField("joinCode", isEqualTo: intCode).getDocuments { [weak self] (snapshot, error) in
                if error != nil {
                    print("error getting documents: \(String(describing: error?.localizedDescription))")
                    return
                } else {
                    guard let self = self, let name = self.user?.displayName else {
                        print("joinChatroom: error retrieving displayName - \(String(describing: error))")
                        return
                    }
                    for document in snapshot!.documents {
                        self.db.collection("chatrooms").document(document.documentID).updateData([
                            "users": FieldValue.arrayUnion([self.user!.uid])
                        ])
                        self.db.collection("chatrooms").document(document.documentID).updateData([
                            "userNames": FieldValue.arrayUnion([name])
                        ])
                        
                        MessagesViewModel().sendMessage(
                            messageContent: "\(name) has joined the chatroom",
                                docId: document.documentID,
                                senderName: "HelloWorld",
                                profilePicture: nil)
                        
                        self.joinCode = ""
                        
                        completion()
                    }
                }
            }
        } else {
            print("cannot join chatroom, user is nil")
            return
        }
    }
    
    func leaveChatroom(code: String, userName: String, completion: @escaping () -> Void) {
        if (user != nil) {
            guard let intCode = Int(code) else {
                print("intCode error")
                return
            }
            db.collection("chatrooms").whereField("joinCode", isEqualTo: intCode).getDocuments { (snapshot, error) in
                if let error = error {
                    print("error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.db.collection("chatrooms").document(document.documentID).updateData([
                            "users": FieldValue.arrayRemove([self.user!.uid])
                        ])
                        self.db.collection("chatrooms").document(document.documentID).updateData([
                            "userNames": FieldValue.arrayRemove([userName])
                        ])
                        
                        MessagesViewModel().sendMessage(
                                messageContent: "\(userName) has left the chatroom",
                                docId: document.documentID,
                                senderName: "HelloWorld",
                                profilePicture: nil)
                        
                        completion()
                    }
                }
            }
        } else {
            print("cannot join chatroom, user is nil")
        }
    }
}
