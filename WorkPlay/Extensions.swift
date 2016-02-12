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
}