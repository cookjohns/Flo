//
//  PushButtonView.swift
//  Flo
//
//  Created by John Cook on 5/26/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit
@IBDesignable

class PushButtonView: UIButton {
    @IBInspectable var fillColor:  UIColor = UIColor.greenColor();
    @IBInspectable var isAddButton: Bool = true;

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func drawRect(rect: CGRect) {
        // create round button
        var path = UIBezierPath(ovalInRect : rect);
        fillColor.setFill();
        path.fill();
        
        // width and height of horizontal stroke
        let plusHeight: CGFloat = 3.0;
        let plusWidth:  CGFloat = min(bounds.width, bounds.height) * 0.6;
        
        // create path
        var plusPath = UIBezierPath();
        
        // set path line width to height of stroke
        plusPath.lineWidth = plusHeight;
        
        // move init point of path to start of horiz stroke
        plusPath.moveToPoint(CGPoint(x:bounds.width/2 - plusWidth/2 + 0.5, y:bounds.height/2 +  0.5));
        
        // add point to path at end of stroke
        plusPath.addLineToPoint(CGPoint(x:bounds.width/2 + plusWidth/2 + 0.5, y:bounds.height/2 + 0.5));
        
        // now do vertical Line
        if (isAddButton) {
            plusPath.moveToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 - plusWidth/2 + 0.5))
        
            plusPath.addLineToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 + plusWidth/2 + 0.5))
        }
        
        // set stroke color and draw
        UIColor.whiteColor().setStroke();
        plusPath.stroke();
    }

}