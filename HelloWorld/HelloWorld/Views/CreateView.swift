//
//  CreateView.swift
//  HelloWorld
//
//  Created by Larry N on 11/16/20.
//

import SwiftUI
import FirebaseAuth

struct CreateView: View {
  @StateObject var chatroomsVM = ChatroomsViewModel()
  @Binding var tabSelection: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("create new chatroom")
        .foregroundColor(Constants.textColor)
        .font(.title)
        .fontWeight(.semibold)
      
      TextFieldView(placeholder: "name your chatroom",
                    image: "textformat.abc",
                    binding: $chatroomsVM.newTitle)
      
      HStack {
        Spacer()
        Button(action: {
          chatroomsVM.createChatroom() {
            tabSelection = 1
          }
        }) {
          Text("create")
        }
        .buttonStyle(PrimaryButtonStyle(condition: chatroomsVM.isTitleValid))
        .disabled(!chatroomsVM.isTitleValid)
        Spacer()
      }
      .padding(.vertical)
    }
    .padding()
  }
}

struct CreateView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      CreateView(tabSelection: .constant(1))
    }
  }
}
