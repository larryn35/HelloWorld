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
                NavigationLink(destination: Messages(for: chatroom)) {
                    ChatListItem(with: chatroom)
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

    init(with chatroom: Chatroom) {
        self.chatroom = chatroom
        messagesViewModel.fetchMessages(docId: chatroom.id)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(chatroom.title).fontWeight(.semibold)
                
                // diplay other users in the chatroom
                if chatroom.userNames.count >= 2 {
                    Text(chatroom.userNames.filter { $0 != userProfileVM.userProfiles.first?.firstName }.joined(separator: ", ")).font(.caption)
                }
                
                if let lastMessage = messagesViewModel.messages.last {
                    Text(lastMessage.name + ": " + lastMessage.content)
                        .lineLimit(1)
                }
            }

            Spacer()
        
        }
    }
}
