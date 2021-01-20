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
//  @Binding var keyboardDisplayed: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("join a chatroom")
        .foregroundColor(Constants.textColor)
        .font(.title)
        .fontWeight(.semibold)
      
      TextFieldView(
        type: .number,
        placeholder: "4-digit join code",
        image: "text.bubble.fill",
        binding: $chatroomsVM.joinCode
      )
      
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
    JoinView(tabSelection: .constant(1))
  }
}
