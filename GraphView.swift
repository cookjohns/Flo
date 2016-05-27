//
//  GraphView.swift
//  Flo
//
//  Created by John Cook on 5/26/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // weekly sample data
    var graphPoints:[Int] = [4,2,6,4,5,8,3];
    
    // properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor();
    @IBInspectable var endColor:   UIColor = UIColor.greenColor();
    
    override func drawRect(rect: CGRect) {
        let width  = rect.width;
        let height = rect.height;
        
        // set up background clipping area
        var path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.AllCorners,
                                cornerRadii: CGSize(width: 8.0, height: 8.0));
        path.addClip();
        
        // get current context
        let context = UIGraphicsGetCurrentContext();
        let colors  = [startColor.CGColor, endColor.CGColor];

        // set up color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // set up color stops
        let colorLocations:[CGFloat] = [0.0, 1.0];
        
        // create gradient
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations);
        
        // draw gradient
        var startPoint = CGPoint.zero;
        var endPoint   = CGPoint(x:0, y: self.bounds.height);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, []);
        
        // calculate x point
        let margin: CGFloat = 20.0;
        var columnXPoint = { (column: Int) -> CGFloat in
            // calc gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.graphPoints.count - 1));
            var x: CGFloat = CGFloat(column) * spacer;
            x += margin + 2;
            return x;
        }
        
        // calc y point
        let topBorder:    CGFloat = 60;
        let bottomBorder: CGFloat = 50;
        let graphHeight = height - topBorder - bottomBorder;
        let maxValue = graphPoints.maxElement();
        var columnYPoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue!) * graphHeight;
            y = graphHeight + topBorder - y; // flip the graph
            return y;
        }
        
        // draw the line for graph
        UIColor.whiteColor().setFill();
        UIColor.whiteColor().setStroke();
        
        // set up the points line
        var graphPath = UIBezierPath();
        // go to start of line
        graphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])));
        // add points for each item in graphPoints array at correct x,y
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]));
            graphPath.addLineToPoint(nextPoint);
        }
        //graphPath.stroke();
        
        // create clipping path for the graph gradient
        
        // save state of context
        CGContextSaveGState(context);
        
        // make copy of the path
        var clippingPath = graphPath.copy() as! UIBezierPath;
        
        // add lines to the copied path
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(graphPoints.count - 1),
            y: height));
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(0),
            y: height));
        clippingPath.closePath();
        
        // add clipping path to context
        clippingPath.addClip();
        
        // create gradient
        let highestYPoint = columnYPoint(maxValue!);
        startPoint = CGPoint(x: margin, y: highestYPoint);
        endPoint   = CGPoint(x: margin, y: self.bounds.height);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, []);
        CGContextRestoreGState(context);
        
        // draw line on top of clipped gradient
        graphPath.lineWidth = 2.0;
        graphPath.stroke();
        
        // draw circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]));
            point.x -= 5.0/2;
            point.y -= 5.0/2;
            
            let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)));
            circle.fill();
        }
        
        // draw horizontal graph lines (on top of everything)
        var linePath = UIBezierPath();
        
        // top line
        linePath.moveToPoint(CGPoint(x: margin, y: topBorder));
        linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder));
        
        // middle line
        linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/2 + topBorder));
        linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/2 + topBorder));
        
        // bottom line
        linePath.moveToPoint(CGPoint(x: margin, y: height - bottomBorder));
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height - bottomBorder));
        
        let color = UIColor(white: 1.0, alpha: 0.3);
        color.setStroke();
        
        linePath.lineWidth = 1.0;
        linePath.stroke();
    }
}