//
//  GlobalClock.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import UIKit

protocol GlobalClockDelegate {
    func clockTick()
}

class GlobalClock: NSObject {

    static let sharedTimer = GlobalClock()
    
    private var clockRunning = false
    
    private var timer: NSTimer!
    
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

    /*
        Returns true if did add task and false for did remove task
    */
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
    
    
}
