//
//  Task.swift
//  WorkPlay
//
//  Created by David Balcher on 2/12/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import Foundation


enum productivityRatio : Double {
    case veryProductive = 0.6,
    somewhatProductive = 0.4,
    lessProductive = 0.2
}

enum TaskMode {
    case standby, work, play, feedback
}


class Task: NSObject {

    var taskMode = TaskMode.standby
    

    // Daily records
    var records = Records()
    
    let timer = GlobalClock.sharedTimer
    
    func workOrPlay(sender: TaskButton) {
        taskMode = sender.toggleMode()
        switch taskMode {
        case .standby:
            break
        case .work:
            records.currentWork = 0
            timer.enable(self)
        case .feedback:
            break
        case .play:
            taskMode = sender.toggleMode()
        }
    }
}
