//
//  TaskTVCell.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, GlobalClockDelegate {
    
    
    var task: Task!
    var timer: GlobalClock!
    
    @IBOutlet weak var taskClock: UILabel!
    @IBOutlet weak var pauseTimerButton: UIButton!
    @IBOutlet weak var barGraphView: BarGraphView!
    @IBOutlet weak var currentGoalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        task = Task()
        timer = GlobalClock.sharedTimer
        timer.delegate = self
    }
    
    func clockTick() {
        updateUI()
    }
    
    func updateUI() {
        
        // Load information about task
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
        let workProgress = task.records.getWorkProgressToDisplay()
        barGraphView.workPercentage = workProgress.workPercentage
        barGraphView.playPercentage = workProgress.playPercentage
        currentGoalLabel.text = workProgress.currentGoal.toCondensedTimeString()
    }
    
    
    @IBAction func workButtonAction(sender: TaskButton) {
        task.workOrPlay(sender)
        switch task.taskMode {
        case .standby, .work, .play:
            break
        case .feedback:
            sender.enabled = false
            askForProductivity(sender)
        }
    }
    
    
    // Ask for productivity in order to add weight play value per work
    
    func askForProductivity(sender: TaskButton) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "How Productive?", message: nil, preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        let productionFeedback = ["😃", "😐", "😔"]
        
        for production in productionFeedback {
            let feedbackAction: UIAlertAction = UIAlertAction(title: production, style: .Default)
                { action -> Void in
                    switch production {
                    case "😃":
                        self.task.records.playToWorkRatio = .veryProductive
                    case "😐":
                        self.task.records.playToWorkRatio = .somewhatProductive
                    case "😔":
                        self.task.records.playToWorkRatio = .lessProductive
                    default:
                        print("error in productivity actionsheet")
                    }
                    sender.enabled = true
                    self.task.taskMode = sender.toggleMode()
                    self.updateUI()
            }
            actionSheetController.addAction(feedbackAction)
        }
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    // Mark: - Pause Task While in Play Mode
    
    @IBAction func pausePlayTime() {
        let didAddTask = timer.toggle(task)
        if didAddTask {
            pauseTimerButton.setTitle("Pause", forState: .Normal)
        } else {
            pauseTimerButton.setTitle("Play", forState: .Normal)
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