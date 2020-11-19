//
//  Messages.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import FirebaseAuth

struct Messages: View {
    
    @State var messageField = ""
    @State var senderName = ""
    @State var senderPicture: String? = ""
    
    let chatroom: Chatroom
    var joinCode = ""
    
    @ObservedObject var messagesViewModel = MessagesViewModel()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    init(for chatroom: Chatroom) {
        self.chatroom = chatroom
        self.joinCode = String(chatroom.joinCode).replacingOccurrences(of: ",", with: "")
        messagesViewModel.fetchMessages(docId: chatroom.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.top)
                    .zIndex(-99)
                
                Color(.white).opacity(0.7)
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: 3.0)
                    .zIndex(-98)
                
                
                VStack {
//                    Text("join code: \(joinCode)")
//                        .padding(12)
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red))
//                        .padding([.top, .horizontal])
                    
                    ScrollView {
                        ScrollViewReader { scrollView in

                            LazyVStack {
                                ForEach(messagesViewModel.messages, id: \.self) { i in
                                    MessageLine(messageDetails: i, users: chatroom.userNames)
                                }
                            }
                            .onAppear {
                                DispatchQueue.main.async {
                                    if let lastMsg = messagesViewModel.lastMessage {
                                        withAnimation {
                                            scrollView.scrollTo(lastMsg)
                                        }
                                    }
                                }
                            }
                            .onChange(of: messagesViewModel.messages) { _ in
                                DispatchQueue.main.async {
                                    if let lastMsg = messagesViewModel.lastMessage {
                                        scrollView.scrollTo(lastMsg)
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
                        
                        Spacer()
                        
                        Button(action: {
                            self.hideKeyboard()
                            if let user = Auth.auth().currentUser?.displayName {
                                messagesViewModel.sendMessage(messageContent: messageField, docId: chatroom.id, senderName: user, profilePicture: userProfileVM.userProfilePicture)
                            } else {
                                print("failed to send message")
                            }
                            messageField = ""
                        }, label: {
                            Text("Send")
                        })
                    }
                    .padding()
                    .background(Color(.white))
                }
                .navigationBarTitle(chatroom.title, displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        Button("Close") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                )
            }
        }
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        
        Messages(for: Chatroom(id: "1000", title: "Hello!", joinCode: 10, userNames: ["John"]))
    }
}
