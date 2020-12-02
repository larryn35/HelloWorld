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
    @StateObject var messagesVM = MessagesViewModel()
    @State private var showMessage = false
    
    var chatroom: Chatroom
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(chatroom.title).fontWeight(.semibold)
                    Spacer()
                    
                    // display last message date
                    if let lastMessage = messagesVM.lastMessage {
                        Text(messagesVM.timeSinceMessage(message: lastMessage.date))
                            .font(.caption)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        // diplay other users in the chatroom
                        if chatroom.userNames.count >= 2,
                           let ownName = Auth.auth().currentUser?.displayName {
                            Text(chatroom.userNames.filter { $0 != ownName }.joined(separator: ", "))
                                .font(.caption)
                        }
                        
                        // display most recent message
                        if let lastMessage = messagesVM.lastMessage {
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
                    Spacer()
                    
                    // display number of unread messages
                    if (messagesVM.messageCount - messagesVM.readMessagesCount) > 0 {
                        Text("\(messagesVM.messageCount - messagesVM.readMessagesCount)")
                            .font(.caption)
                            .padding(5)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showMessage = true
            }
            .onAppear {
                messagesVM.fetchMessages(docId: chatroom.id)
                messagesVM.fetchNumberOfReadMessages(docId: chatroom.id)
            }
            .sheet(isPresented: $showMessage, content: {
                Messages(for: chatroom)
                    .onDisappear {
                        messagesVM.openedMessage(docId: chatroom.id)
                    }
            })
        }
    }
}
