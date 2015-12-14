//
//  ChartViewController.swift
//  Baby Kicking
//
//  Created by Vinh Nguyen on 12/13/15.
//  Copyright © 2015 Axcoto. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import Charts

struct TimerangeConstant{
    static let testStr = "test"
    
    static let arrayOfTests: [String] = ["foo", "bar", testStr]
}

struct Hour {
    var day = 0
    var hour = 0
    var minute = 0
}

class ChartViewController: UIViewController {
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var timePickerButton: UIButton!
    var timerange: Int = 1
    
    let realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) {
        refreshChart()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        refreshChart()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeGroupBy(sender: UIButton) {

        let alertController = UIAlertController(title: "Time range", message: "Change time range", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        
        let lasthourAction = UIAlertAction(title: "Last hour", style: .Default) { (action) in
            self.timerange = 1
            self.timePickerButton.titleLabel?.text = "Last hour"
            self.refreshChart()
        }
        alertController.addAction(lasthourAction)
        
        let last8hoursAction = UIAlertAction(title: "Last 8 hours", style: .Default) { (action) in
            self.timerange = 8
            self.timePickerButton.titleLabel?.text = "Last 8 hours"
            self.refreshChart()
        }
        alertController.addAction(last8hoursAction)
        
        let Hour12Action = UIAlertAction(title: "Last 12 hours", style: .Default) { (action) in
            self.timerange = 12
            self.timePickerButton.titleLabel?.text = "Last 12 hours"
            self.refreshChart()
        }
        alertController.addAction(Hour12Action)

        let DayAction = UIAlertAction(title: "Last day", style: .Default) { (action) in
            self.timerange = 24
            self.timePickerButton.titleLabel?.text = "Last day"
            self.refreshChart()
        }
        alertController.addAction(DayAction)
        
        let Day3Action = UIAlertAction(title: "Last 3 days", style: .Default) { (action) in
            self.timerange = 72
            self.timePickerButton.titleLabel?.text = "Last 3 days"
            self.refreshChart()
        }
        alertController.addAction(Day3Action)
        
        let Day7Action = UIAlertAction(title: "Last 7 days", style: .Default) { (action) in
            self.timerange = 24 * 7
            self.timePickerButton.titleLabel?.text = "Last 7 days"
            self.refreshChart()
        }
        alertController.addAction(Day7Action)
        
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    
    func calculateDataPoint() -> (time: [String], data: [Double]){
        let calendar = NSCalendar.currentCalendar()
        
        let kicks = realm.objects(Kick)
        print("Using timezone %s", NSTimeZone.defaultTimeZone())

        let threshold = 100
        var count = 0
        var time: [String] = []
        var data: [Double] = []
        
        var roundMinute = 5
        if timerange >= 24 {
            roundMinute = 15
        }
        
        if timerange >= 72 {
            roundMinute = 60
        }
        
        let date = NSDate()
        let component = calendar.components([ .Day, .Hour, .Minute, .Second], fromDate: date)
        let startDate = date.dateByAddingTimeInterval(-3600 * Double(timerange))
        let startTimeComponent = calendar.components([ .Day, .Hour, .Minute, .Second], fromDate: startDate)
        
        let startAt = Hour(day: startTimeComponent.day, hour: startTimeComponent.hour, minute: startTimeComponent.minute - (startTimeComponent.minute % roundMinute))
        let endAt   = Hour(day: component.day, hour: component.hour, minute: component.minute + (roundMinute - component.minute % roundMinute))
        
        print("Chart starts at %v", startAt)
        print("Chart ends at %v", endAt)
        var points: [String:Double] = [:]
        

        //http://stackoverflow.com/questions/26198526/nsdate-comparison-using-swift
        var iTime = startDate
        while iTime.timeIntervalSince1970 < date.timeIntervalSince1970 {
            let c = calendar.components([ .Day, .Hour, .Minute, .Second], fromDate: iTime)
            points["\(c.day) \(c.hour):\(c.minute - c.minute % roundMinute)"] = Double(0)
            iTime = iTime.dateByAddingTimeInterval(60 * Double(roundMinute))
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:m"
        
        for kick in kicks {
            if count >= threshold {
                break
            }
            count += 1

            if let kickedAt = kick.createdAt {
                let component = calendar.components([ .Day, .Hour, .Minute, .Second], fromDate: kickedAt)
                if let counter = points["\(component.day) \(component.hour):\(component.minute - component.minute % roundMinute)"] {
                    points["\(component.day) \(component.hour):\(component.minute - component.minute % roundMinute)"] = counter + 1.0
                }
            }
            
        }
        
        for (t, d) in points {
            time.append(t)
            data.append(d)
        }
            
        return (time, data)
    }
    
    func refreshChart() {
        let chartData = calculateDataPoint()
        drawchart(chartData.time, values: chartData.data)
    }
    
    func drawchart(dataPoints: [String], values: [Double]) {
        chartView.noDataText = "Not enough data yet"
        

        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Kicks")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
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
