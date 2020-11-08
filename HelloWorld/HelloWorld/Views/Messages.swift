//
//  Messages.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import Firebase

struct Messages: View {
    
    @State var messageField = ""
    @State var senderName = ""
    @State var senderPicture: String? = ""

    let chatroom: Chatroom
    var joinCode = ""
    
    @ObservedObject var messagesViewModel = MessagesViewModel()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        self.joinCode = String(chatroom.joinCode).replacingOccurrences(of: ",", with: "")
        messagesViewModel.fetchData(docId: chatroom.id)
        userProfileVM.fetchProfile()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Join code: \(joinCode)")
                    .font(.footnote)
                Spacer()
            }
            .padding(.horizontal)
            
            List(messagesViewModel.messages) { i in
                if Auth.auth().currentUser?.email == i.email  {
                    MessageLine(ownMessage: true, messageDetails: i)
                } else {
                    MessageLine(ownMessage: false, messageDetails: i)
                }
            }
            
            HStack {
                TextField("Enter message...", text: $messageField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    messagesViewModel.sendMessage(messageContent: messageField, docId: chatroom.id, senderName: senderName, profilePicture: senderPicture)
                    messageField = ""
                }, label: {
                    Text("Send")
                })
            }
            .padding(.horizontal)
        }
        .onAppear {
            guard !userProfileVM.userProfiles.isEmpty else { return }
            senderName = userProfileVM.userProfiles[0].firstName + " " + userProfileVM.userProfiles[0].lastName
            senderPicture = userProfileVM.userProfiles[0].profilePicture ?? nil
        }
        .navigationBarTitle(chatroom.title)
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        
        Messages(chatroom: Chatroom(id: "1000", title: "Hello!", joinCode: 10))
    }
}
