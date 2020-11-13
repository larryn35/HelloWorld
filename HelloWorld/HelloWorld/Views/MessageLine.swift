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
    
    var messageDetails = Message(content: "", name: "", email: "")
    var users = [String]()
        
    @State var timestamp = false
            
    var body: some View {
        
        if Auth.auth().currentUser?.email == messageDetails.email  {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(messageDetails.content)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(#colorLiteral(red: 0.873228865, green: 0.9759244819, blue: 1, alpha: 1)))
                        .cornerRadius(20)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.04255843915, blue: 0.09319479696, alpha: 1)))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(#colorLiteral(red: 0, green: 0.04255843915, blue: 0.09319479696, alpha: 1)), lineWidth: 1))
                        .onTapGesture {
                            withAnimation {
                                timestamp.toggle()
                            }
                        }
                    if timestamp {
                        Text(timeSinceMessage(message: messageDetails.date))
                            .font(.caption)
                    }
                }
            }
            
        } else {
            HStack(alignment:.bottom, spacing: 10) {
                
                if messageDetails.profilePicture == nil {
                    Image("IconClear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
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
                            // TODO: rewrite code for color
                            .foregroundColor(userColor(user: messageDetails.name, users: users))
                        Spacer()
                    }
                    Text(messageDetails.content)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(userColor(user: messageDetails.name, users: users),lineWidth: 1))
                        .onTapGesture {
                            withAnimation {
                                timestamp.toggle()
                            }
                        }
                    
                    if timestamp {
                        Text(timeSinceMessage(message: messageDetails.date))
                            .font(.caption)
                    }
                }
                Spacer()
            }
        }
    }
}

//struct MessageLine_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            MessageLine(ownMessage: true, message: "Hello world, how are you?", sender: "John")
//            MessageLine(ownMessage: false, message: "This is a very long message that is supposed to take up many lines what do you think abo", sender: "John")
//        }
//    }
//}
