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
    @IBInspectable var workPercentage: Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Current available play time in seconds
    @IBInspectable var playPercentage: Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    
    override func drawRect(rect: CGRect) {
        let horizontalSpacing: Double = 6.0
        let maxWidth = Double(rect.width) - (2.0 * horizontalSpacing)
        let height = 10.0
    
        
        let workY: Double = Double(rect.height)/2 - 12.0
        let workBKRect = CGRect(x: horizontalSpacing, y: workY, width: maxWidth, height: height)
        let workBK = UIBezierPath(roundedRect: workBKRect, cornerRadius: 2.0)
        UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.3).setFill()
        workBK.fill()
        
        let workBarRect = CGRect(x: horizontalSpacing, y: workY, width: maxWidth*workPercentage, height: height)
        let workBar = UIBezierPath(roundedRect: workBarRect, cornerRadius: 2.0)
        UIColor.redColor().setFill()
        workBar.fill()
        
        let playY: Double = Double(rect.height)/2 + 2.0
        let playBKRect = CGRect(x: horizontalSpacing, y: playY, width: maxWidth, height: height)
        let playBK = UIBezierPath(roundedRect: playBKRect, cornerRadius: 2.0)
        UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.3).setFill()
        playBK.fill()
        
        let playBarRect = CGRect(x: horizontalSpacing, y: playY, width: maxWidth*playPercentage, height: height)
        let playBar = UIBezierPath(roundedRect: playBarRect, cornerRadius: 2.0)
        UIColor.blueColor().setFill()
        playBar.fill()
    }
}
