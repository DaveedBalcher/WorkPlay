//
//  TaskTVCell.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import UIKit

class TaskTVCell: UITableViewCell {
    
    var task: Task? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var taskClock: UILabel!
    @IBOutlet weak var pauseTimerButton: UIButton!
    @IBOutlet weak var barGraphView: BarGraphView!
    
    func updateUI() {
        
        // Load information about task
        if let task = self.task {
            switch task.taskMode {
            case .work:
                taskClock.text = task.records.currentWork.toTimeString()
                pauseTimerButton.hidden = true
            case .play:
                let play = task.records.currentPlay
                taskClock.text = play.toTimeString()
                pauseTimerButton.hidden = play > 0 ? false : true                
            case .standby, .feedback:
                break
            }
            barGraphView.workTotal = task.records.dailyTotalWork
            barGraphView.currentPlay = task.records.currentPlay
        }
    }
}

class TaskButton: UIButton {
    var taskMode = TaskMode.standby
    
    func toggleMode() -> TaskMode {
        switch self.taskMode {
        case .work:
            self.setTitle("WORK", forState: UIControlState.Normal)
            self.taskMode = .feedback
        case .standby,
             .play:
            self.setTitle("PLAY", forState: UIControlState.Normal)
            self.taskMode = .work
        case .feedback:
            self.taskMode = .play
        }
        return self.taskMode
    }
}