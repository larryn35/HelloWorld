//
//  Messages.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Messages: View {
    
    @State var messageField = ""
    @State var senderName = ""
    @State var senderPicture: String? = ""
    
    let chatroom: Chatroom
    var joinCode = ""
    
    @ObservedObject var messagesViewModel = MessagesViewModel()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        self.joinCode = String(chatroom.joinCode).replacingOccurrences(of: ",", with: "")
        messagesViewModel.fetchData(docId: chatroom.id)
        userProfileVM.fetchProfile()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Join code: \(joinCode)")
                    .font(.footnote)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                ScrollViewReader { scrollView in
                    LazyVStack {
                        ForEach(messagesViewModel.messages, id:\.content) { i in
                            MessageLine(messageDetails: i)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            if let lastMsg = messagesViewModel.messages.last?.content {
//                                withAnimation {
                                    scrollView.scrollTo(lastMsg)
//                                }
                            }
                        }
                    }
                    .onChange(of: messagesViewModel.messages) { _ in
                        DispatchQueue.main.async {
                            if let lastMsg = messagesViewModel.messages.last?.content {
                                withAnimation {
                                    scrollView.scrollTo(lastMsg)
                                }
                            }
                        }
                    }
                }
                .padding()
                .ignoresSafeArea(.keyboard)
                .padding(.bottom, 0)
            }
            
            HStack {
                TextField("Enter message...", text: $messageField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.hideKeyboard()

                    messagesViewModel.sendMessage(messageContent: messageField, docId: chatroom.id, senderName: senderName, profilePicture: senderPicture)
                    messageField = ""
                }, label: {
                    Text("Send")
                })
            }
            .padding(.horizontal)
        }

        .onAppear {
            guard !userProfileVM.userProfiles.isEmpty else { return }
            senderName = userProfileVM.userProfiles[0].firstName + " " + userProfileVM.userProfiles[0].lastName
            senderPicture = userProfileVM.userProfiles[0].profilePicture ?? nil
        }
        .navigationBarTitle(chatroom.title)
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        
        Messages(chatroom: Chatroom(id: "1000", title: "Hello!", joinCode: 10))
    }
}
