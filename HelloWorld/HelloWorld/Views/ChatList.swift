//
//  ChatList.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct ChatList: View {
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    @State var joinModal = false
    
    init() {
        chatroomsViewModel.fetchData()
    }
    
    var body: some View {
        NavigationView {
            List(chatroomsViewModel.chatrooms) { chatroom in
                HStack {
                    Text(chatroom.title)
                    Spacer()
                }
                .navigationBarTitle("Welcome")
                .navigationBarItems(trailing: Button(action: {
                    joinModal = true
                }, label: {
                    Image(systemName: "plus.circle")
                }))
                .sheet(isPresented: $joinModal, content: {
                    Join(isOpen: $joinModal)
                })
            }
        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
