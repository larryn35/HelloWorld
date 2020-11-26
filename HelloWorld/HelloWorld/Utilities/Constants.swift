//
//  Constants.swift
//  HelloWorld
//
//  Created by Larry N on 11/23/20.
//

import SwiftUI

enum Constants {
    static let color1 = Color("Color1")
    static let color2 = Color("Color2")
    static let title = Color("Title")
    static let fill = Color("FillColor")
    static let primary = Color("Primary")
    
    static let gradientBackground = LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let contentWidth = UIScreen.main.bounds.width - 50
    static let buttonWidth = UIScreen.main.bounds.width - 150
}

