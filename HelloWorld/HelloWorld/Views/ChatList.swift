//
//  ChatList.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct ChatList: View {
    
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("chatrooms")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.semibold)
            
            List(chatroomsViewModel.chatrooms) { chatroom in
                ChatListItem(with: chatroom)
                    .padding(.vertical)
            }
            .cornerRadius(10)
        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}


struct ChatListItem: View {
    var chatroom: Chatroom
    @State var timestamp = ""

    @ObservedObject var messagesViewModel = MessagesViewModel()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    
    @State private var showMessage = false
    
    init(with chatroom: Chatroom) {
        self.chatroom = chatroom
    }
    
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
                if chatroom.userNames.count >= 2 {
                    Text(chatroom.userNames.filter { $0 != userProfileVM.userProfiles.first?.firstName }.joined(separator: ", ")).font(.caption)
                }
                
                // display most recent message
                if let lastMessage = messagesViewModel.messages.last {
                    Text(lastMessage.name + ": " + lastMessage.content)
                        .lineLimit(1)
                        .font(.caption2)
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

