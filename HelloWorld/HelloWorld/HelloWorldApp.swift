//
//  HelloWorldApp.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI
import Firebase

@main
struct HelloWorldApp: App {
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}
