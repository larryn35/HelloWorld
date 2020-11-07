//
//  ChatList.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct ChatList: View {
    
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    @ObservedObject var sessionStore = SessionStore()
    @State var joinModal = false
    
    init() {
        chatroomsViewModel.fetchData()
    }
    
    var body: some View {
        NavigationView {
            List(chatroomsViewModel.chatrooms) { chatroom in
                NavigationLink(destination: Messages(chatroom: chatroom)) {
                    HStack {
                        Text(chatroom.title)
                        Spacer()
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
                Join(isOpen: $joinModal)
            })
        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
