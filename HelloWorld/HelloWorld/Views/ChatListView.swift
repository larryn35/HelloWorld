//
//  ChatListView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import FirebaseAuth

struct ChatListView: View {
    @StateObject var chatroomsViewModel = ChatroomsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("chatrooms")
                .foregroundColor(Constants.title)
                .font(.title)
                .fontWeight(.semibold)
            
            List(chatroomsViewModel.chatrooms) { chatroom in
                ChatListItem(chatroom: chatroom)
                    .padding(.vertical)
            }
            .shadowStyle()
        }
        .padding()
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}

struct ChatListItem: View {
    @StateObject var messagesViewModel = MessagesViewModel()
    @State private var showMessage = false
    
    var chatroom: Chatroom
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(chatroom.title).fontWeight(.semibold)
                    Spacer()
                    
                    // display last message date
                    if let lastMessage = messagesViewModel.lastMessage {
                        Text(messagesViewModel.timeSinceMessage(message: lastMessage.date))
                            .font(.caption)
                    }
                }
                
                // diplay other users in the chatroom
                if chatroom.userNames.count >= 2,
                   let ownName = Auth.auth().currentUser?.displayName {
                    Text(chatroom.userNames.filter { $0 != ownName }.joined(separator: ", "))
                        .font(.caption)
                }
                
                // display most recent message
                if let lastMessage = messagesViewModel.lastMessage {
                    if lastMessage.name == Auth.auth().currentUser?.displayName {
                        Text("You: " + lastMessage.content)
                            .lineLimit(1)
                            .font(.caption2)
                    } else {
                        Text(lastMessage.name + ": " + lastMessage.content)
                            .lineLimit(1)
                            .font(.caption2)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showMessage = true
            }
            .onAppear {
                messagesViewModel.fetchMessages(docId: chatroom.id)
            }
            .sheet(isPresented: $showMessage, content: {
                Messages(for: chatroom)
            })
        }
    }
}

