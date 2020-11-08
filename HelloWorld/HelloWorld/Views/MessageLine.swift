//
//  MessageLine.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageLine: View {
    
    var ownMessage = false
    var messageDetails = Message(content: "", name: "", email: "")
    
    var body: some View {
        
        if ownMessage {
            HStack {
                Spacer()
                Text(messageDetails.content)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .foregroundColor(.white)
            }
            
        } else {
            HStack(alignment:.bottom, spacing: 10) {
    
                if messageDetails.profilePicture == nil {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40.5, height: 40.5)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                } else {
                    if let url = messageDetails.profilePicture {
                        WebImage(url: URL(string: url))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 40.5, height: 40.5)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                    }
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(messageDetails.name)
                            .font(.caption)
                        Spacer()
                    }
                    Text(messageDetails.content)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.green)
                        .cornerRadius(20)
                        .foregroundColor(.white)
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
