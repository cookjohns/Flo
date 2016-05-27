//
//  ViewController.swift
//  Flo
//
//  Created by John Cook on 5/26/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var counterView:   CounterView!
    @IBOutlet weak var counterLabel:  UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView:     GraphView!
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel:      UILabel!
    
    var isGraphViewShowing = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        counterLabel.text = String(counterView.counter);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPushButton(button: PushButtonView) {
        if (button.isAddButton) {
            counterView.counter = counterView.counter+1;
        } else {
            if counterView.counter > 0 {
                counterView.counter = counterView.counter-1;
            }
        }
        counterLabel.text = String(counterView.counter);
        
        if (isGraphViewShowing) {
            counterViewTap(nil);
        }
    }
    
    @IBAction func counterViewTap(gesture:UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            // hide Graph
            UIView.transitionFromView(graphView,
                                      toView: counterView,
                                      duration: 1.0,
                                      options: [UIViewAnimationOptions.TransitionFlipFromLeft, UIViewAnimationOptions.ShowHideTransitionViews],
                                      completion:nil)
        } else {
            // show Graph   
            setupGraphDisplay();
            UIView.transitionFromView(counterView,
                                      toView: graphView,
                                      duration: 1.0,
                                      options: [UIViewAnimationOptions.TransitionFlipFromRight, UIViewAnimationOptions.ShowHideTransitionViews],
                                      completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    func setupGraphDisplay() {
        let noOfDays: Int = 7;
        
        // replace last day with today's data
        graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter;
        
        // mark graph for redraw
        graphView.setNeedsDisplay();

        maxLabel.text = "\(graphView.graphPoints.maxElement()!)";
        
        // calc avg from graph points
        let average = graphView.graphPoints.reduce(0, combine: +) / graphView.graphPoints.count;
        averageWaterDrunk.text = "\(average)";
        
        // set up labels
        // day of week labels are set up in storyboard with tags 1-7
        // today is last day of the array, need to go backwards
        
        // get today's day number
        let dateFormatter = NSDateFormatter();
        let calendar      = NSCalendar.currentCalendar();
        //let componentOptions: NSCalendarUnit = .CalendarUnitWeekday;
        let components    = calendar.components(.Weekday, fromDate: NSDate());
        var weekday       = components.weekday;
        
        // make sure to set up backwards
        let days = ["S","S","M","T","W","Th","F"];
        
        // set up day name labels with correct day
        for i in days.count.stride(through: 1, by:-1) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                print(weekday);
                if (weekday == 7) {
                    weekday = 0;
                }
                labelView.text = days[weekday];
                weekday = weekday-1;
                if weekday < 0 {
                    weekday = days.count - 1;
                }
            }
        }
    }
}