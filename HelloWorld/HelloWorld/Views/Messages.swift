//
//  Messages.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Messages: View {
    
    @State var messageField = ""
    let chatroom: Chatroom
    @ObservedObject var messagesViewModel = MessagesViewModel()
    
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        messagesViewModel.fetchData(docId: chatroom.id
        )
    }
    
    var body: some View {
        VStack {
            List(messagesViewModel.messages) { message in
                HStack {
                    Text(message.content)
                    Spacer()
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
