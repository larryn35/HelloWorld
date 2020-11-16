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

    var body: some View {
        
        TabView {
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
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                    .zIndex(-99)
                
                Join()
                    
            }
            .tabItem {
                Image(systemName: "plus")
                Text("add/join chatroom")
            }
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                    .zIndex(-99)
                
                Text("signout").onTapGesture {
                    sessionStore.signOut()
                }
                    
            }
            .tabItem {
                Image(systemName: "person")
                Text("settings")
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
