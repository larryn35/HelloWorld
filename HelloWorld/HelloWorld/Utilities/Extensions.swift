//
//  Extensions.swift
//  HelloWorld
//
//  Created by Larry N on 11/25/20.
//

import SwiftUI

// Dismiss keyboard on tap
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
