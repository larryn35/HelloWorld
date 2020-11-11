//
//  ChatList.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct ChatList: View {
    
    @State var joinModal = false
    
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    @ObservedObject var sessionStore = SessionStore()
    
    var body: some View {
        NavigationView {
            List(chatroomsViewModel.chatrooms) { chatroom in
                ZStack {
                    ChatListItem(with: chatroom)
                    NavigationLink(destination: Messages(for: chatroom)) {
                        EmptyView()
                    }
                }
            }
            .navigationBarTitle("Welcome")
            .navigationBarItems(
                leading: Button(action: {
                    sessionStore.signOut()
                }, label: {
                    Text("Sign out")
                }),
                
                trailing: Button(action: {
                    joinModal = true
                }, label: {
                    Image(systemName: "plus.circle")
                })
            )
            .sheet(isPresented: $joinModal, content: {
                // send user's name when creating/joining chatroom
                Join(isOpen: $joinModal, userName: userProfileVM.userProfiles.first?.firstName ?? "Error")
            })
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
    
    @ObservedObject var messagesViewModel = MessagesViewModel()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    
    init(with chatroom: Chatroom) {
        self.chatroom = chatroom
        messagesViewModel.fetchMessages(docId: chatroom.id)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(chatroom.title).fontWeight(.semibold)
                Spacer()
                
                // display last message date
                if let lastMessage = messagesViewModel.messages.last {
                    Text(timeSinceMessage(message: lastMessage.date))
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
    }
}
