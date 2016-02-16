//
//  Records.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import Foundation

struct Records {
    
    // Daily records in seconds
    var currentWork = 0 {
        didSet {
            if currentWork != 0 {
                currentPlay++
            } else if oldValue != 0 {
                workSessions.append(oldValue)
//                currentPlayDouble = Double(oldValue) * playToWorkRatio
                playSessions.append(currentPlay)
            }
        }
    }
    
    private var currentPlayDouble = 0.0
    var currentPlay: Int = 0 {
        didSet {
            if currentPlay > oldValue {
                currentPlayDouble += playToWorkRatio.rawValue
            } else if currentPlay < oldValue && currentPlay >= 0 {
                currentPlayDouble--
            }
            currentPlay = Int(currentPlayDouble)
        }
    }
    
    var dailyTotalWork: Int {
        return currentWork + workSessions.reduce(0, combine: +)
    }
    
    var workSessions: [Int] = []
    var playSessions: [Int] = []
    
    var playToWorkRatio: productivityRatio = .somewhatProductive {
        didSet {
            currentPlayDouble += Double(currentWork) * (playToWorkRatio.rawValue - oldValue.rawValue)
            currentPlay++
        }
    }
    
    var masterWorkCalender: [NSDate: [Int]] = [:]
    
    mutating func commitDailyRecord() {
        masterWorkCalender[NSDate()] = workSessions
    }
}