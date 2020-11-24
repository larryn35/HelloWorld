//
//  Messages.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import FirebaseAuth

struct Messages: View {
    @ObservedObject var messagesVM = MessagesViewModel()
    @ObservedObject var userProfileVM = UserProfileViewModel()
    @ObservedObject var chatroomVM = ChatroomsViewModel()
    
    @State var messageField = ""
    @State var senderName = ""
    @State var senderPicture: String? = ""
    @State var showPopover = false
    @State var showAlert = false
    
    let chatroom: Chatroom
    var joinCode = ""
        
    @Environment(\.presentationMode) var presentationMode
    
    init(for chatroom: Chatroom) {
        self.chatroom = chatroom
        self.joinCode = String(chatroom.joinCode).replacingOccurrences(of: ",", with: "")
        messagesVM.fetchMessages(docId: chatroom.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Constants.gradientBackground
                    .edgesIgnoringSafeArea(.top)
                    .zIndex(-99)
                
                Color(.white).opacity(0.7)
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: 3.0)
                    .zIndex(-98)
                
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
                        TextField("Enter message...", text: $messageField)
                        
                        Spacer()
                        
                        Button(action: {
                            if let user = Auth.auth().currentUser?.displayName {
                                messagesVM.sendMessage(messageContent: messageField, docId: chatroom.id, senderName: user, profilePicture: userProfileVM.userProfilePicture)
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
                    leading:
                        Button(action: {
                            withAnimation{
                                showPopover.toggle()
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
                
                if showPopover {
                    Color(.black).opacity(0.6).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            withAnimation{
                                showPopover.toggle()
                            }
                        }
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.7)))
                    
                    Popover(chatroom: chatroom, joinCode: joinCode, showAlert: $showAlert)
                        .padding()
                        .transition(.move(edge: .leading))
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("leave chatroom?"),
                      message: Text("your messages will still be visible to others"),
                      primaryButton: .destructive(Text("leave")) {
                        
                        if let userName = Auth.auth().currentUser?.displayName {
                            chatroomVM.leaveChatroom(code: joinCode, userName: userName) {
                                showPopover.toggle()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                      },
                      secondaryButton: .cancel())
            })
        }
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        Messages(for: Chatroom(id: "1000", title: "Hello!", joinCode: 10, userNames: ["John"]))
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
        .background(Color.white)
        .cornerRadius(10)
    }
}
