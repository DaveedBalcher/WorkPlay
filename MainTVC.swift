//
//  MainTVC.swift
//  WorkPlay
//
//  Created by David Balcher on 2/9/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController, GlobalClockDelegate {
    
    var tasks = [Task]()
    var selectedTask = 0
    
    let timer = GlobalClock.sharedTimer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer.delegate = self
        tasks.append(Task())
    }
    
    func clockTick() {
        self.tableView.reloadData()
    }
    
    @IBAction func workButtonAction(sender: TaskButton) {
        tasks[selectedTask].workOrPlay(sender)
        switch tasks[selectedTask].taskMode {
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
                    self.tasks[self.selectedTask].records.playToWorkRatio = .veryProductive
                case "😐":
                    self.tasks[self.selectedTask].records.playToWorkRatio = .somewhatProductive
                case "😔":
                    self.tasks[self.selectedTask].records.playToWorkRatio = .lessProductive
                default:
                    print("error in productivity actionsheet")
                }
                    sender.enabled = true
                    self.tasks[self.selectedTask].taskMode = sender.toggleMode()
            }
            actionSheetController.addAction(feedbackAction)
        }
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    // Mark: - Pause Task While in Play Mode
    
    //    @IBOutlet weak var pauseButton: UIButton!
    //
    //    @IBAction func pausePlayTime() {
    //        let didAddTask = timer.toggle(self)
    //        if didAddTask {
    //            pauseButton.setTitle("Pause", forState: .Normal)
    //        } else {
    //            pauseButton.setTitle("Play", forState: .Normal)
    //        }
    //    }
    
    
    // Mark: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "fullTaskCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TaskTVCell
        cell.task = tasks[selectedTask]
        
        return cell
        
    }
}
