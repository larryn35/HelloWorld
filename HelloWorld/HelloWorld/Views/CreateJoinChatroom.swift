//
//  CreateJoinChatroom.swift
//  HelloWorld
//
//  Created by Larry N on 11/16/20.
//

import SwiftUI
import FirebaseAuth

struct CreateChatroom: View {
    @ObservedObject var chatroomsVM = ChatroomsViewModel()

    @Binding var tabSelection: Int

    @State var showAlert = false
    @State var errorMessage = ""
    @State var newTitle = ""

    var userName = Auth.auth().currentUser?.displayName ?? ""

    var completedForm: Bool {
        !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
        
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text("create new chatroom")
                    .foregroundColor(Constants.title)
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
                .background(Constants.fill)
                .shadowStyle()
            }
            
            Button(action: {
                chatroomsVM.createChatroom(title: newTitle, userName: userName) {
                    newTitle = ""
                    self.hideKeyboard()
                    tabSelection = 1
                }
                
            }, label: {
                Text("create")
                    .padding(8)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .foregroundColor(.white)
                    .background(completedForm ? Color.red : Color.gray.opacity(0.5))
                    .shadowStyle()
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
    @ObservedObject var chatroomsViewModel = ChatroomsViewModel()
    
    @Binding var tabSelection: Int

    @State var showAlert = false
    @State var errorMessage = ""
    @State var joinCode = ""

    var userName = Auth.auth().currentUser?.displayName ?? ""
    
    var completedForm: Bool {
        joinCode.count == 4
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text("join a chatroom")
                    .foregroundColor(Constants.title)
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
                .background(Constants.fill)
                .shadowStyle()
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
                    .background(completedForm ? Color.red : Color.gray.opacity(0.5))
                    .shadowStyle()
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
