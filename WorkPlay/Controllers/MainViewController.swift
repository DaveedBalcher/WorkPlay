//
//  MainViewController.swift
//  WorkPlay
//
//  Created by David Balcher on 2/16/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var tasks = [Task]()
    var selectedTask = 0
    
    let timer = GlobalClock.sharedTimer
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tasks.append(Task())
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
