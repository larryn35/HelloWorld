//
//  UserMessageColor.swift
//  HelloWorld
//
//  Created by Larry N on 11/11/20.
//

import SwiftUI
import UIKit

func userColor(user: String, users: [String]) -> Color {
    let firstName = user.components(separatedBy: " ").first ?? ""
    var color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    switch firstName {
    case users[0]:
        color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    case users[1]:
        color = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    case users[2]:
        color = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    case users[3]:
        color = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
    case users[4]:
        color = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
    default:
        color = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    }
    
    return Color(color)
}
