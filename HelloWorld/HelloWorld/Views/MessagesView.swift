//
//  MessagesView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @ObservedObject var messagesVM = MessagesViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var chatroomVM = ChatroomsViewModel()
    
    private let chatroom: Chatroom
    private var joinCode = ""
        
    @Environment(\.presentationMode) var presentationMode
    
    init(for chatroom: Chatroom) {
        self.chatroom = chatroom
        self.joinCode = String(chatroom.joinCode).replacingOccurrences(of: ",", with: "")
        messagesVM.fetchMessages(docId: chatroom.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Constants.gradientBackground.opacity(0.2)
                    .edgesIgnoringSafeArea([.top, .bottom])
                
                VStack {
                    ScrollView {
                        ScrollViewReader { scrollView in
                            LazyVStack {
                                ForEach(messagesVM.messages, id: \.self) { i in
                                    MessageLine(messageDetails: i, users: chatroom.userNames)
                                }
                            }
                            .onAppear {
                                if let lastMsg = messagesVM.lastMessage {
                                    withAnimation {
                                        scrollView.scrollTo(lastMsg)
                                    }
                                }
                            }
                            .onChange(of: messagesVM.messages) { _ in
                                if let lastMsg = messagesVM.lastMessage {
                                    scrollView.scrollTo(lastMsg)
                                }
                            }
                        }
                        .padding()
                        .ignoresSafeArea(.keyboard)
                        .padding(.bottom, 0)
                    }
                    
                    HStack {
                        TextField("Enter message...", text: $messagesVM.messageField)
                        
                        Spacer()
                        
                        Button(action: {
                            if let user = Auth.auth().currentUser?.displayName {
                                messagesVM.sendMessage(messageContent: messagesVM.messageField, docId: chatroom.id, senderName: user, profilePicture: profileVM.profilePicture)
                            } else {
                                print("failed to send message")
                            }
                            messagesVM.messageField = ""
                        }) {
                            Text("Send")
                        }
                        .onAppear {
                            profileVM.fetchProfilePicture()
                        }
                    }
                    .padding()
                    .background(Constants.primary)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .padding(.horizontal)
                }
                .navigationBarTitle(chatroom.title, displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button(action: {
                            withAnimation{
                                messagesVM.showPopover.toggle()
                            }
                        }, label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding()
                        })
                    
                    , trailing:
                        Button("Close") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                )
                
                if messagesVM.showPopover {
                    Color(.black).opacity(0.6).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            withAnimation{
                                messagesVM.showPopover.toggle()
                            }
                        }
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.7)))
                    
                    Popover(chatroom: chatroom, joinCode: joinCode, showAlert: $messagesVM.showAlert)
                        .padding()
                        .transition(.move(edge: .leading))
                }
            }
            .alert(isPresented: $messagesVM.showAlert, content: {
                Alert(title: Text("Leave chatroom?"),
                      message: Text("Your messages will still be visible to others"),
                      primaryButton: .destructive(Text("Leave")) {
                        
                        if let userName = Auth.auth().currentUser?.displayName {
                            chatroomVM.leaveChatroom(code: joinCode, userName: userName) {
                                messagesVM.showPopover.toggle()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                      },
                      secondaryButton: .cancel())
            })
        }
        .accentColor(Constants.title)
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(for: Chatroom(id: "1000", title: "Hello!", joinCode: 10, userNames: ["John"]))
    }
}

struct Popover: View {
    var chatroom: Chatroom
    var joinCode: String
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("join code:")
                .fontWeight(.semibold)
            Text(joinCode)
            
            Divider()
            
            Text("who's here:")
                .fontWeight(.semibold)
            ForEach(chatroom.userNames, id:\.self) { user in
                Text(user)
            }
            
            Divider()
            
            Button(action: {
                showAlert = true
            }, label: {
                Text("leave chatroom")
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
            })
        }
        .frame(width: 150)
        .padding()
        .background(Constants.primary)
        .cornerRadius(10)
    }
}
