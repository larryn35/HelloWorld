//
//  Home.swift
//  HelloWorld
//
//  Created by Larry N on 11/14/20.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    
    @ObservedObject var sessionStore = SessionStore()

    @State var tabSelection = 1

    var body: some View {
        
        TabView(selection: $tabSelection) {

            // MARK:  Chatroom List

            ZStack {
                Constants.gradientBackground
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(-99)
                
                ChatList()
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("chatrooms")
            }
            .tag(1)
            
            // MARK:  Create or join chatroom

            ZStack {
                Constants.gradientBackground
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(-99)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                
                VStack(spacing: 120) {
                    CreateChatroom(tabSelection: $tabSelection)
                    JoinChatroom(tabSelection: $tabSelection)
                    Spacer()
                }
            }
            .tabItem {
                Image(systemName: "plus")
                Text("create/join chatroom")
            }
            .tag(2)

            // MARK:  Settings
            
            ZStack {
                Constants.gradientBackground
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(-99)
                
                ProfileSettings()
            }
            .tabItem {
                Image(systemName: "person")
                Text("settings")
            }
            .tag(3)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
