//
//  JoinView.swift
//  HelloWorld
//
//  Created by Larry N on 11/28/20.
//

import SwiftUI
import FirebaseAuth

struct JoinView: View {
    @StateObject var chatroomsVM = ChatroomsViewModel()
    @Binding var tabSelection: Int
    @Binding var keyboardDisplayed: Bool
    @State var showAlert = false
    
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
                    
                    TextField("4-digit join code", text: $chatroomsVM.joinCode)
                        .keyboardType(.numberPad)
                        .onTapGesture {
                            withAnimation {
                                keyboardDisplayed = true
                            }
                        }
                }
                .padding()
                .padding(.vertical)
                .background(Constants.fill)
                .shadowStyle()
            }
            
            Button(action: {
                chatroomsVM.joinChatroom(code: chatroomsVM.joinCode) {
                    self.hideKeyboard()
                    tabSelection = 1
                }
            }) {
                Text("join")
            }
            .buttonStyle(PrimaryButtonStyle(condition: chatroomsVM.isCodeValid))
            .disabled(!chatroomsVM.isCodeValid)
        }
        .padding()
    }
}

struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView(tabSelection: .constant(1), keyboardDisplayed: .constant(false))
    }
}
