//
//  Join.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import FirebaseAuth

struct Join: View {
    
//    @Binding var isOpen: Bool
    @State var joinCode = ""
    @State var newTitle = ""
//    @State var userName = ""
    
    private var userName = Auth.auth().currentUser?.displayName ?? ""
    
    private var codeInputCount: Bool {
        joinCode.count == 4
    }
    private var correctChatTitle: Bool {
        !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack {
                    Text("Join a chatroom")
                        .font(.title)
                    TextField("Enter your 4-digit join code", text: $joinCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        chatroomsViewModel.joinChatroom(code: joinCode, userName: userName) {
//                            isOpen = false
                        }
                    }, label: {
                        Text("Join")
                            .modifier(ButtonStyle(validation: codeInputCount))
                    })
                    .disabled(!codeInputCount)
                }
                
                VStack {
                    Text("Create a chatroom")
                        .font(.title)
                    TextField("Enter a title", text: $newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        chatroomsViewModel.createChatroom(title: newTitle, userName: userName) {
//                           isOpen = false
                        }
                    }, label: {
                        Text("Create")
                            .modifier(ButtonStyle(validation: correctChatTitle))
                    })
                    .disabled(!correctChatTitle)
                }
            }
            .padding()
            .navigationBarTitle("Join or create")
        }
    }
}

struct Join_Previews: PreviewProvider {
    static var previews: some View {
        Join()
    }
}
