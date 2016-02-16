//
//  BarGraphView.swift
//  WorkPlay
//
//  Created by David Balcher on 2/15/16.
//  Copyright © 2016 DavidBalcher. All rights reserved.
//

import UIKit

@IBDesignable class BarGraphView: UIView {
    
    // Total seconds worked today
    @IBInspectable var workTotal: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Current available play time in seconds
    @IBInspectable var currentPlay: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Daily work goal in hours
    var dailyWorkGoal: Int =  12
    var currentGoal: Int!
    
    private var workPercentage: CGFloat {
        let work: CGFloat = workTotal > 0 ? CGFloat(workTotal) : 1.0
        let goal = CGFloat(dailyWorkGoal * 360)
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
            print("Error: in barGraphView calculating zoom options")
        }
        return work / CGFloat(currentGoal)
    }
    
    private var playPercentage: CGFloat {
        let play: CGFloat = currentPlay > 0 ? CGFloat(currentPlay) : 1.0
        return play / CGFloat(currentGoal)
    }
    
    override func drawRect(rect: CGRect) {
        let horizontalSpacing: CGFloat = 6.0
        let maxWidth = rect.width - (2.0 * horizontalSpacing)
    
        
        let workY: CGFloat = rect.height/2 - 12.0
        let workBKRect = CGRect(x: horizontalSpacing, y: workY, width: maxWidth, height: 10.0)
        let workBK = UIBezierPath(roundedRect: workBKRect, cornerRadius: 2.0)
        UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.3).setFill()
        workBK.fill()
        
        let workBarRect = CGRect(x: horizontalSpacing, y: workY, width: maxWidth*workPercentage, height: 10.0)
        let workBar = UIBezierPath(roundedRect: workBarRect, cornerRadius: 2.0)
        UIColor.redColor().setFill()
        workBar.fill()
        
        let playY: CGFloat = rect.height/2 + 2.0
        let playBKRect = CGRect(x: horizontalSpacing, y: playY, width: maxWidth, height: 10.0)
        let playBK = UIBezierPath(roundedRect: playBKRect, cornerRadius: 2.0)
        UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.3).setFill()
        playBK.fill()
        
        let playBarRect = CGRect(x: horizontalSpacing, y: playY, width: maxWidth*playPercentage, height: 10.0)
        let playBar = UIBezierPath(roundedRect: playBarRect, cornerRadius: 2.0)
        UIColor.blueColor().setFill()
        playBar.fill()
    }
}
