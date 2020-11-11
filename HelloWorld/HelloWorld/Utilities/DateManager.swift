//
//  DateManager.swift
//  HelloWorld
//
//  Created by Larry N on 11/10/20.
//

import Foundation

func timeSinceMessage(message: Date) -> String  {
    let dateFormatter = DateFormatter()
    let relDateFormatter = RelativeDateTimeFormatter()
    relDateFormatter.unitsStyle = .short

    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([Calendar.Component.minute], from: message, to: Date())

    guard let minute = dateComponents.minute
    else {
        return ("error getting hour")
    }
    // greater than 6 days (>8640 mins), show date
    if Int(minute) > 8640 {
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: message)
        
    // greater than 2 hours (> 120 mins), show day of the week
    } else if Int(minute) > 120 {
        dateFormatter.dateFormat = "E h:mm a"
        return dateFormatter.string(from: message)
    } else {
        
        // less than 2 hours, use relative time
        return relDateFormatter.string(for: message) ?? "error formatting date"
    }
}
