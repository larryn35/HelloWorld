//
//  ChatListView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import FirebaseAuth

struct ChatListView: View {
  @ObservedObject var chatroomsVM: ChatroomsViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("chatrooms")
        .foregroundColor(Constants.textColor)
        .font(.title)
        .fontWeight(.semibold)
      
      if chatroomsVM.chatrooms.isEmpty {
        List{
          HStack {
            Spacer()
            VStack(spacing: 20) {
              Image(systemName: "bubble.left.and.bubble.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
              Text("chatrooms will appear here")
                .font(.title2)
              Text("create or join one below")
            }
            .padding(.top, 50)
            Spacer()
          }
        }
        .shadowStyle()
      } else {
        List(chatroomsVM.chatrooms) { chatroom in
          ChatListItem(chatroomsVM: chatroomsVM, chatroom: chatroom)
            .padding(.vertical, 3)
        }
        .shadowStyle()
      }
    }
    .padding()
    .onAppear {
      chatroomsVM.fetchChatRoomData()
    }
  }
}

struct ChatList_Previews: PreviewProvider {
  static var previews: some View {
    ChatListView(chatroomsVM: ChatroomsViewModel())
  }
}

struct ChatListItem: View {
  @StateObject var messagesVM = MessagesViewModel()
  @ObservedObject var chatroomsVM: ChatroomsViewModel
  @State private var showMessage = false
  
  var chatroom: Chatroom
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        HStack {
          Text(chatroom.title).fontWeight(.semibold)
          Spacer()
          
          // Display last message date
          if let lastMessage = messagesVM.lastMessage {
            Text(messagesVM.timeSinceMessage(message: lastMessage.date))
              .font(.caption)
          }
        }
        
        HStack {
          VStack(alignment: .leading) {
            // Display other users in the chatroom
            if chatroom.userNames.count >= 2,
               let ownName = Auth.auth().currentUser?.displayName {
              Text(chatroom.userNames.filter { $0 != ownName }.joined(separator: ", "))
                .lineLimit(1)
                .font(.caption)
                .padding(.bottom, 1)
            }
            
            // Display most recent message
            if let lastMessage = messagesVM.lastMessage {
              if lastMessage.name == Auth.auth().currentUser?.displayName {
                Text("You: " + lastMessage.content)
                  .lineLimit(1)
                  .foregroundColor(.secondary)
                  .font(.caption2)
              } else {
                Text(lastMessage.name + ": " + lastMessage.content)
                  .lineLimit(1)
                  .foregroundColor((messagesVM.messageCount - messagesVM.readMessagesCount) > 0 ? .primary : .secondary)
                  .font(.caption2)
              }
            }
          }
          Spacer()
          
          // Display number of unread messages
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
        MessagesView(chatroomVM: chatroomsVM, chatroom: chatroom)
          .onDisappear {
            messagesVM.openedMessage(docId: chatroom.id)
          }
      })
    }
  }
}
