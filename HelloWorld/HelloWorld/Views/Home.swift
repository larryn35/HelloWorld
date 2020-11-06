//
//  ContentView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Home: View {
    @ObservedObject var sessionStore = SessionStore()
    
    init() {
        sessionStore.listen()
    }
        
    var body: some View {
        ChatList()
            .fullScreenCover(isPresented: $sessionStore.isAnon, content: {
                Login()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
