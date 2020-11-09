//
//  Join.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Join: View {
    
    @Binding var isOpen: Bool
    @State var joinCode = ""
    @State var newTitle = ""
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack {
                    Text("Join a chatroom")
                        .font(.title)
                    TextField("Enter your join code", text: $joinCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        chatroomsViewModel.joinChatroom(code: joinCode) {
                            isOpen = false
                        }
                    }, label: {
                        Text("Join")
                            .modifier(ButtonStyle())
                    })
                }
                
                VStack {
                    Text("Create a chatroom")
                        .font(.title)
                    TextField("Enter a title", text: $newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        chatroomsViewModel.createChatroom(title: newTitle) {
                            isOpen = false
                        }
                    }, label: {
                        Text("Create")
                            .modifier(ButtonStyle())
                    })
                }
            }
            .padding()
            .navigationBarTitle("Join or create")
        }
    }
}

struct Join_Previews: PreviewProvider {
    static var previews: some View {
        Join(isOpen: .constant(true))
    }
}
