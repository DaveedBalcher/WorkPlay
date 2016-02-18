//
//  Records.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//


/*
    Record the users work and play time for a current session and entire work calender.
*/

import Foundation

struct Records {
    
    // Daily records in seconds
    var currentWork = 0 {
        didSet {
            if currentWork != 0 {
                currentPlay++
            } else if oldValue != 0 {
                workSessions.append(oldValue)
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

    
    // Daily work goal in hours
    var dailyWorkGoal: Int = 12
    
    var dailyTotalWork: Int {
        return currentWork + workSessions.reduce(0, combine: +)
    }
    
    func  getWorkProgressToDisplay() -> (workPercentage: Double, playPercentage: Double, currentGoal: Int) {
        let work: Double = dailyTotalWork > 0 ? Double(dailyTotalWork) : 1.0
        let play: Double = currentPlay > 0 ? Double(currentPlay) : 1.0
        
        let goal = Double(dailyWorkGoal * 360)
        var currentGoal = 0
        switch work {
        case 0..<60:
            currentGoal = 300
        case 60..<300:
            currentGoal = 600
        case 300..<600:
            currentGoal = 1800
        case 600..<1800:
            currentGoal = 3600
        case goal/16..<goal/8:
            currentGoal = (dailyWorkGoal / 8) * 360
        case goal/8..<goal/4:
            currentGoal = (dailyWorkGoal / 4) * 360
        case goal/4..<goal/2:
            currentGoal = (dailyWorkGoal / 4) * 720
        case goal/2...goal:
            currentGoal = (dailyWorkGoal) * 360
        default:
            print("Error: in Records calculating work progress")
        }
        return (work / Double(currentGoal), play / Double(currentGoal), currentGoal)
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