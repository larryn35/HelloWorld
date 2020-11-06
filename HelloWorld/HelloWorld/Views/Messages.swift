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
    let chatroom: Chatroom
    var name = ""
    
    @ObservedObject var messagesViewModel = MessagesViewModel()
        
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        messagesViewModel.fetchData(docId: chatroom.id
        )
    }
    
    var body: some View {
        VStack {
            List(messagesViewModel.messages) { i in
                if Auth.auth().currentUser?.email == i.name  {
                    MessageLine(ownMessage: true, message: i.content, sender: i.name)
                } else {
                    MessageLine(ownMessage: false, message: i.content, sender: i.name)

                }
            }
            
            HStack {
                TextField("Enter message...", text: $messageField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    messagesViewModel.sendMessage(messageContent: messageField, docId: chatroom.id)
                }, label: {
                    Text("Send")
                })
            }
        }
        .navigationBarTitle(chatroom.title)
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        
        Messages(chatroom: Chatroom(id: "1000", title: "Hello!", joinCode: 10))
    }
}
