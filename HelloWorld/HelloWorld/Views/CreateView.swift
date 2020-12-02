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
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text("create new chatroom")
                    .foregroundColor(Constants.title)
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack(spacing: 15) {
                    Image(systemName: "textformat.abc")
                        .frame(width:20)
                    
                    TextField("name your chatroom", text: $chatroomsVM.newTitle)
                        .autocapitalization(.none)
                }
                .padding()
                .padding(.vertical)
                .background(Constants.fill)
                .shadowStyle()
            }
            
            Button(action: {
                chatroomsVM.createChatroom() {
                    self.hideKeyboard()
                    tabSelection = 1
                }
                
            }) {
                Text("create")
                    .buttonStyle(condition: chatroomsVM.isTitleValid)
            }
            .offset(y: 20)
            .disabled(!chatroomsVM.isTitleValid)
            
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
