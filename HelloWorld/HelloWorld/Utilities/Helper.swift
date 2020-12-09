//
//  Helper.swift
//  HelloWorld
//
//  Created by Larry N on 11/26/20.
//

import Foundation

class Helper {
    static func validateForm(for strings: [String]) -> Bool {
        var results = [Bool]()
        for string in strings {
            // field does not pass validation (false) if is empty / contains just spaces
            results.append(!string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        
        // if any of the fields fail, return false, otherwise true
        if results.contains(false) {
            return false
        } else {
            return true
        }
    }
}
