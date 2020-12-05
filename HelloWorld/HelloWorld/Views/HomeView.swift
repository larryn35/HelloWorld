//
//  HomeView.swift
//  HelloWorld
//
//  Created by Larry N on 11/14/20.
//

import SwiftUI

struct HomeView: View {
    @State var tabSelection = 1
    @State var keyboardDisplayed = false

    var body: some View {
        
        TabView(selection: $tabSelection) {
            // MARK:  Chatroom List
            ZStack {
                Constants.gradientBackground
                    .edgesIgnoringSafeArea(.all)
                ChatListView()
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
                    .onTapGesture {
                        withAnimation {
                            self.hideKeyboard()
                            keyboardDisplayed = false
                        }
                    }
                HStack(alignment: .top){
                    VStack(spacing: !keyboardDisplayed ? 120 : 30) {
                        CreateView(tabSelection: $tabSelection, keyboardDisplayed: $keyboardDisplayed)
                        JoinView(tabSelection: $tabSelection, keyboardDisplayed: $keyboardDisplayed)
                        Spacer()
                    }
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
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                Text("settings")
            }
            .tag(3)
        }
        .accentColor(Constants.title)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
