//
//  NSDate+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

enum NSDateFormat: Int {
    case style1 = 0 ///yyyy-MM-dd HH:mm:ss
    case style2 = 1 ///yyyy-MM-dd
    case style3 = 2 ///yyyy年MM月dd日
}

private var startDate: NSDate?

extension NSDate {

    static func startTime() -> Void {
        startDate = NSDate.now as NSDate
    }
    
    static func endTime() -> Void {
        if startDate != nil {
            NSLog("time: %f", -startDate!.timeIntervalSinceNow)
            self.startTime()
        }
    }

    static func time(callback: @escaping () -> ()) -> Void {
        let startDate: NSDate = NSDate.now as NSDate
        callback()
        NSLog("time: %f", -startDate.timeIntervalSinceNow)
    }
    
    static func dateWithFormat(_ format: NSDateFormat) -> String {
        let formatString: String = self.stringWithFormat(format)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formatString
        return formatter.string(from: NSDate.now)
    }
    
    static func dateWithString(_ aString: String, format: NSDateFormat) -> NSDate {
        let formatString: String = self.stringWithFormat(format)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formatString
        return formatter.date(from: aString)! as NSDate
    }
    
    static func weekdayFromDate(_ date: NSDate) -> NSDate {
        let weekdays: NSArray = NSArray.init(array: ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"])
        let calendar: NSCalendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.chinese)!
        let timeZone: NSTimeZone = NSTimeZone.init(name: "Asia/Shanghai")!
        calendar.timeZone = timeZone as TimeZone
        let theComponents: NSDateComponents = calendar.components(in: timeZone as TimeZone, from: date as Date) as NSDateComponents
        return weekdays.object(at: theComponents.weekday) as! NSDate
    }
    
    static func pastWithDays(_ days: Int, format: NSDateFormat) -> String {
        return self.pastWithDate(NSDate.now as NSDate, days: days, format: format)
    }
    
    static func pastWithDate(_ date: NSDate, days: Int, format: NSDateFormat) -> String {
        let formatString: String = self.stringWithFormat(format)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formatString
        let pastDay: NSDate = self.pastWithDate(date, days: days)
        return formatter.string(from: pastDay as Date)
    }
    
    static func pastWithDays(_ days: Int) -> NSDate {
        return self.pastWithDate(NSDate.now as NSDate, days: days)
    }
    
    static func pastWithDate(_ date: NSDate, days: Int) -> NSDate {
        let time: TimeInterval = TimeInterval(days * 24 * 60 * 60)
        return date.addingTimeInterval(-time)
    }
    
    static private func stringWithFormat(_ format: NSDateFormat) -> String {
        var formatString: String
        switch format {
        case .style1:
            formatString = "yyyy-MM-dd HH:mm:ss"
        case .style2:
            formatString = "yyyy-MM-dd"
        case .style3:
            formatString = "yyyy年MM月dd日"
        }
        return formatString
    }
    
}
