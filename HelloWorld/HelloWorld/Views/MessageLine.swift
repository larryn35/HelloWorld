//
//  MessageLine.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct MessageLine: View {
    
    var messageDetails: Message
    var usersInChatroom: [String]
    
    @State var timestamp = false
    
    @ObservedObject var messagesVM = MessagesViewModel()
    
    var body: some View {
        
        if messageDetails.name == "HelloWorld" {
            VStack {
                Text(messageDetails.content)
                    .font(.caption)
                    .padding()
                    .background(Color.secondary.opacity(0.4))
                    .opacity(0.8)
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            timestamp.toggle()
                        }
                    }
                
                if timestamp {
                    Text(messagesVM.timeSinceMessage(message: messageDetails.date))
                        .font(.caption)
                }
            }
            
        } else if messageDetails.senderID == Auth.auth().currentUser?.uid {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(messageDetails.content)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(.blue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                timestamp.toggle()
                            }
                        }
                    if timestamp {
                        Text(messagesVM.timeSinceMessage(message: messageDetails.date))
                            .font(.caption)
                    }
                }
            }
            
        } else {
            HStack(alignment:.bottom, spacing: 10) {
                
                if messageDetails.profilePicture == nil || messageDetails.profilePicture == "" {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40.5, height: 40.5)
                    
                } else {
                    if let url = messageDetails.profilePicture {
                        WebImage(url: URL(string: url))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 40.5, height: 40.5)
                    }
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(messageDetails.name)
                            .font(.caption)
                            .foregroundColor(
                              messagesVM.userColor(
                                for: messageDetails.name,
                                from: usersInChatroom)
                            )
                        Spacer()
                    }
                    Text(messageDetails.content)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Constants.bubbleColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation {
                                timestamp.toggle()
                            }
                        }
                    
                    if timestamp {
                        Text(messagesVM.timeSinceMessage(message: messageDetails.date))
                            .font(.caption)
                    }
                }
                Spacer()
            }
        }
    }
}


struct MessageLine_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text("Hello, how are you?")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color(.blue))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
    }
}
