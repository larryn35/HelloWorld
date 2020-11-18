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
                
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                    .zIndex(-99)
                
                ChatList()
                    .padding()
                    
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("chatrooms")
            }
            .tag(1)
            
            // MARK:  Create or join chatroom

            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                    .zIndex(-99)
                
                VStack(spacing: 120) {
                    CreateChatroom(tabSelection: $tabSelection)
                    JoinChatroom(tabSelection: $tabSelection)
                }
            }
            .tabItem {
                Image(systemName: "plus")
                Text("create/join chatroom")
            }
            .tag(2)

            // MARK:  Settings
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
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
