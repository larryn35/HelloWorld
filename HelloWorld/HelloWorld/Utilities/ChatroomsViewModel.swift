//
//  ChatroomsViewModel.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import Foundation
import Firebase

struct Chatroom: Codable, Identifiable {
    var id: String
    var title: String
    var joinCode: Int
    var userNames: [String]
}

class ChatroomsViewModel: ObservableObject {
    @Published var chatrooms = [Chatroom]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    init() {
        fetchChatRoomData()
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
    
    func createChatroom(title: String, userName: String, completion: @escaping () -> Void) {
        if (user != nil) {
            db.collection("chatrooms")
                .addDocument(data: [
                    "title": title,
                    "joinCode": Int.random(in: 1000..<9999),
                    "users": [user!.uid],
                    "userNames": [userName]
                ]) { error in
                    if let error = error {
                        print("error adding document: \(error)")
                    } else {
                        completion()
                    }
                }
        }
    }
    
    func joinChatroom(code: String, userName: String, completion: @escaping () -> Void) {
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
                            "users": FieldValue.arrayUnion([self.user!.uid])
                        ])
                        self.db.collection("chatrooms").document(document.documentID).updateData([
                            "userNames": FieldValue.arrayUnion([userName])
                        ])
                        
                        completion()
                    }
                }
            }
        } else {
            print("cannot join chatroom, user is nil")
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
                        
                        completion()
                    }
                }
            }
        } else {
            print("cannot join chatroom, user is nil")
        }
    }
}
