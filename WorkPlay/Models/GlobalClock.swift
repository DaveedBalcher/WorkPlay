//
//  GlobalClock.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

/*
    A Global Clock set to trigger every second can be shared to sync different classes
*/

import UIKit

protocol GlobalClockDelegate {
    func clockTick()
}

class GlobalClock: NSObject {

    static let sharedTimer = GlobalClock()
    
    var clockRunning = false
    
    private var timer: NSTimer!
    
    
    // Instances of the Task class are appended and removed from activeTasks. Active Tasks are sent a signal trigger by a timer. If no tasks are active, the timer invalidates.
    
    var activeTasks: [Task] = [] {
        didSet {
            if activeTasks.count != 0 && !clockRunning {
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "count", userInfo: nil, repeats: true)
                clockRunning = true
            } else if activeTasks.count == 0 && clockRunning {
                timer.invalidate()
                clockRunning = false
                print("empty")
            }
        }
    }
    
    func enable(taskController: Task) {
        if !activeTasks.contains(taskController) {
            activeTasks.append(taskController)
        }
    }

    
    // Toggle been active and inactive for specified task.
    // Returns true if did add task and false for did remove task.
    
    func toggle(currentTask: Task) -> Bool {
        if activeTasks.contains(currentTask) {
            for (index, task) in activeTasks.enumerate() {
                if task == currentTask {
                    activeTasks.removeAtIndex(index)
                }
            }
            return false
        } else {
            activeTasks.append(currentTask)
            return true
        }
    }
    
    
    
    // Trigger each active task when timer ticks
    
    var delegate: GlobalClockDelegate?
    
    private var previousPlay = 0
    
    func count() {
        for (index, task) in activeTasks.enumerate() {
            switch task.taskMode {
            case .work:
                task.records.currentWork++
            case .play:
                previousPlay = task.records.currentPlay--
                if task.records.currentPlay <= 0 && previousPlay == 0 {
                    task.taskMode = .standby
                    activeTasks.removeAtIndex(index)
                }
            case .standby, .feedback:
                break
            }
            delegate?.clockTick()
        }
    }
    
    
    // Add sleep time to each active task when device returns from background
    
    func step(timeInterval: Int) {
        for (index, task) in activeTasks.enumerate() {
            switch task.taskMode {
            case .work:
                task.records.currentWork += timeInterval
            case .play:
                previousPlay = task.records.currentPlay
                task.records.currentPlay -= timeInterval
                if task.records.currentPlay <= 0 && previousPlay == 0 {
                    task.taskMode = .standby
                    activeTasks.removeAtIndex(index)
                }
            case .standby, .feedback:
                break
            }
            delegate?.clockTick()
        }
    }
    
}
