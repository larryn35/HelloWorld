//
//  CreateJoinChatroom.swift
//  HelloWorld
//
//  Created by Larry N on 11/16/20.
//

import SwiftUI
import FirebaseAuth

struct CreateChatroom: View {
    
    @State var showAlert = false
    @State var errorMessage = ""
    @State var newTitle = ""

    var completedForm: Bool {
        !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var userName = Auth.auth().currentUser?.displayName ?? ""

    @Binding var tabSelection: Int

    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text("create new chatroom")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack(spacing: 15) {
                    Image(systemName: "textformat.abc")
                        .frame(width:20)
                    
                    TextField("name your chatroom", text: $newTitle)
                        .autocapitalization(.none)
                }
                .padding()
                .padding(.vertical)
                .background(Color(.white))
                .cornerRadius(10)
                .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
            }
            
            Button(action: {
                chatroomsViewModel.createChatroom(title: newTitle, userName: userName) {
                    newTitle = ""
                    self.hideKeyboard()
                    tabSelection = 1
                }
                
            }, label: {
                Text("create")
                    .padding(8)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .foregroundColor(.white)
                    .background(completedForm ? Color.red : Color.gray)
                    .cornerRadius(10)
                    .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
            })
            .offset(y: 20)
            .disabled(!completedForm)
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Please try again"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct JoinChatroom: View {
    
    @State var showAlert = false
    @State var errorMessage = ""
    @State var joinCode = ""

    var completedForm: Bool {
        joinCode.count == 4
    }
    var userName = Auth.auth().currentUser?.displayName ?? ""
    
    @Binding var tabSelection: Int
    
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text("join a chatroom")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack(spacing: 15) {
                    Image(systemName: "text.bubble.fill")
                        .frame(width:20)
                    
                    TextField("4-digit join code", text: $joinCode)
                        .keyboardType(.numberPad)
                }
                .padding()
                .padding(.vertical)
                .background(Color(.white))
                .cornerRadius(10)
                .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)                
            }
            
            Button(action: {
                chatroomsViewModel.joinChatroom(code: joinCode, userName: userName) {
                    joinCode = ""
                    self.hideKeyboard()
                    tabSelection = 1
                }
                
            }, label: {
                Text("join")
                    .padding(8)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .foregroundColor(.white)
                    .background(completedForm ? Color.red : Color.gray)
                    .cornerRadius(10)
                    .shadow(color: Color(.black).opacity(0.3), radius: 4, x: 4, y: 4)
            })
            .offset(y: 20)
            .disabled(!completedForm)
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Please try again"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct CreateJoinChatroom_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CreateChatroom(tabSelection: .constant(1))
            JoinChatroom(tabSelection: .constant(1))
        }
    }
}
