//
//  CounterView.swift
//  Flo
//
//  Created by John Cook on 5/26/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

let NoOfGlasses = 8;
let π:CGFloat = CGFloat(M_PI);

@IBDesignable class CounterView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var counter: Int = 5 {
        didSet {
            if (counter <= NoOfGlasses) {
                // view needs to be refreshed
                setNeedsDisplay();
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor();
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor();
    
    override func drawRect(rect: CGRect) {
        // 1
        let center = CGPoint(x:bounds.width/2, y:bounds.height/2);
        // 2
        let radius: CGFloat = max(bounds.width, bounds.height);
        // 3
        let arcWidth: CGFloat = 76;
        // 4
        let startAngle: CGFloat = 3 * π / 4;
        let endAngle: CGFloat = π / 4;
        // 5
        var path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true);
        // 6
        path.lineWidth = arcWidth;
        counterColor.setStroke();
        path.stroke();
        
        // draw arc outline
        
        // calculate difference between angles (ensure positive)
        let angleDifference: CGFloat = 2*π - startAngle + endAngle;
        // calculate arc for each single glass
        let arcLengthPerGlass = angleDifference / CGFloat(NoOfGlasses);
        // multiply out by the actual number of glasses drunk
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle;
        //draw outer arc
        var outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - 2.5,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true);
        // draw inner arc
        outlinePath.addArcWithCenter(center,
                                     radius: bounds.width/2 - arcWidth + 2.5,
                                     startAngle: outlineEndAngle,
                                     endAngle: startAngle,
                                     clockwise: false)
        // close the path
        outlinePath.closePath();
        
        outlineColor.setStroke();
        outlinePath.lineWidth = 5.0;
        outlinePath.stroke();
        
        // draw markers
        let context = UIGraphicsGetCurrentContext();
        
        // save original state
        CGContextSaveGState(context);
        outlineColor.setFill();
        
        let markerWidth: CGFloat = 5.0;
        let markerSize:  CGFloat = 10.0;
        
        // marker rectangle positioned at top left
        var markerPath = UIBezierPath(rect:
            CGRect(x: -markerWidth/2,
                y: 0,
                width: markerWidth,
                height: markerSize));
        
        // move top left of context to previous center position
        CGContextTranslateCTM(context, rect.width/2, rect.height/2);
        
        for i in 1...NoOfGlasses {
            // save centered context
            CGContextSaveGState(context);
            
            // calc rotation angle
            var angle = arcLengthPerGlass * CGFloat(i) + startAngle - π/2;
            
            //rotate and translate
            CGContextRotateCTM(context, angle);
            CGContextTranslateCTM(context, 0, rect.height/2 - markerSize);
            
            // fill marker rectangle
            markerPath.fill();
            
            // restore centered context for next rotation
            CGContextRestoreGState(context);
        }
        // restore the original state in case of more painting
        CGContextRestoreGState(context);
    }
    
}