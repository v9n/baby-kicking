//
//  ChartViewController.swift
//  Baby Kicking
//
//  Created by Vinh Nguyen on 12/13/15.
//  Copyright © 2015 Axcoto. All rights reserved.
//

import UIKit
import Foundation
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
    let chart: Chart = Chart()

    
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
        
        for (t,v) in chart.timeranges() {
            let action = UIAlertAction(title: t, style: .Default) { (action) in
                self.chart.timerange = v
                self.timePickerButton.titleLabel?.text = t
                self.refreshChart()
            }
            alertController.addAction(action)
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func refreshChart() {
        let chartData = chart.calculateDataPoint()
        print(chartData)
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
        chartView.descriptionText = ""
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
