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

class ChartViewController: UIViewController {
    @IBOutlet weak var chartView: BarChartView!

    
    let realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) {
        let chartData = calculateDataPoint()
        drawchart(chartData.time, values: chartData.data)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let chartData = calculateDataPoint()
        drawchart(chartData.time, values: chartData.data)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeGroupBy(sender: UIButton) {

        let alertController = UIAlertController(title: "Time range", message: "Change time range", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Last hour", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Last 8 hours", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        let Hour12Action = UIAlertAction(title: "Last 12 hours", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(Hour12Action)

        let DayAction = UIAlertAction(title: "Last day", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(DayAction)
        
        let Day3Action = UIAlertAction(title: "Last 3 days", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(Day3Action)
        
        let Day7Action = UIAlertAction(title: "Last 7 days", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(Day7Action)
        
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
        
    }
    
    
    func calculateDataPoint() -> (time: [String], data: [Double]){
        let kicks = realm.objects(Kick)
        print("Using timezone %s", NSTimeZone.defaultTimeZone())

        let threshold = 100
        var count = 0
        var time: [String] = []
        var data: [Double] = []
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm"
        
        for kick in kicks {
            if count >= threshold {
                break
            }
            count += 1
            print(kick)
            print(kick.createdAt)
                        print(kick.count)
                        print("Time %s", kick.createdAt)
            
            let at: String
            if let kickedAt = kick.createdAt {
                at = formatter.stringFromDate(kickedAt)
                if time.contains(at) {
                    data[data.count - 1] += 1
                } else {
                    print("append %s", at)
                    time.append(at)
                    data.append(1)
                }
            }
            
        }
        
        return (time, data)
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
