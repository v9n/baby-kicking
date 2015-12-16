//
//  Chart.swift
//  Baby Kicking
//
//  Created by Vinh Nguyen on 12/14/15.
//  Copyright © 2015 Axcoto. All rights reserved.
//

import Foundation
import RealmSwift

class Chart {
    let realm = try! Realm()
    var timerange: Int = 1
    
    func timeranges() -> [String:Int] {
        return [
            "Now": 1,
            "8 hours": 8,
            "12 hours": 12,
            "today": 24,
            "3 days": 72,
            "7 days": 24 * 7,
            "30 days": 24 * 30,
            "all times": 6 * 24 * 30, //6 months
        ]
    }
    
    func calculateDataPoint() -> (time: [String], data: [Double]){
        let calendar = NSCalendar.currentCalendar()
        
        let kicks = realm.objects(Kick)
        print("Using timezone %s", NSTimeZone.defaultTimeZone())
        
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
        let startDate = date.dateByAddingTimeInterval(-3600 * Double(timerange))
        
        var points: [String:Double] = [:]
        
        //http://stackoverflow.com/questions/26198526/nsdate-comparison-using-swift
        var iTime = startDate
        var timeAxis = [String]()
        while iTime.timeIntervalSince1970 <= date.timeIntervalSince1970 {
            let c = calendar.components([ .Day, .Month, .Hour, .Minute, .Second], fromDate: iTime)
            let key = "\(c.month)/\(c.day) \(c.hour):\(c.minute + (roundMinute - c.minute % roundMinute))"
            timeAxis.append(key)
            points[key] = Double(0)
            iTime = iTime.dateByAddingTimeInterval(60 * Double(roundMinute))
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm"
        
        for kick in kicks {
            
            if let kickedAt = kick.createdAt {
                if kickedAt.timeIntervalSince1970 < startDate.timeIntervalSince1970 || kickedAt.timeIntervalSince1970 >= date.timeIntervalSince1970 {
                    continue
                }
                
                let component = calendar.components([ .Day, .Month, .Hour, .Minute, .Second], fromDate: kickedAt)
                if let counter = points["\(component.month)/\(component.day) \(component.hour):\(component.minute + roundMinute - component.minute % roundMinute)"] {
                    points["\(component.month)/\(component.day) \(component.hour):\(component.minute + roundMinute - component.minute % roundMinute)"] = counter + 1.0
                }
            }
            
        }
        
        for t in timeAxis {
            time.append(t)
            if let counter = points[t] {
                data.append(counter)
            } else {
                data.append(0)
            }
        }
        
        return (time, data)
    }

}