//
//  Extensions.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import UIKit


// Extensions
extension Int {
    func toTimeString() -> String {
        let hours = String(format: "%02d", self/3600)
        let minutes = String(format: "%02d", (self/60) % 60)
        let seconds = String(format: "%02d", self % 60)
        return hours + ":" + minutes + ":" + seconds
    }
    
    func toCondensedTimeString() -> String {
        var minutes = (Int(self)/60)
        minutes = minutes > 0 ? minutes : 1
        switch minutes {
        case 0..<60:
            return "\(minutes)\""
        case 60..<1440:
            return "\(minutes/60)\'"
        case 1440..<10080:
            return "\(minutes/1440) day"
        case 10080..<43200:
            return "\(minutes/10080) wk"
        case 43200..<525600:
            return "\(minutes/43200) mth"
        default:
            return "\(minutes/525600) yr"
        }
    }

}