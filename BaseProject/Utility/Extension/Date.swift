//
//  Date.swift
//  BaseProject
//
//  Created by MacMini-2 on 15/06/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import Foundation

// MARK:   - NSDate Extension -

public extension Date
{
    /**
     Initialize a date object using the given string.
     
     :param: dateString the string that will be used to instantiate the date object. The string is expected to be in the format 'yyyy-MM-dd hh:mm:ss a'.
     
     :returns: the NSDate object.
     */
    public init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let d = dateStringFormatter.date(from: dateString)
        if let unwrappedDate = d {
            self.init(timeInterval:0, since:unwrappedDate)
        } else {
            self.init()
        }
    }
    
    
    /**
     Returns a string of the date object using the format 'yyyy-MM-dd hh:mm:ss a'.
     
     :returns: a formatted string object.
     */
    public func toString() -> String {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        return dateStringFormatter.string(from: self)
    }
    
    public func getCurrentUTCTimeStampe() -> TimeInterval
    {
        let date = Date();
        
        let dateFormatter = DateFormatter()
        
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        
        let UTCDate = dateFormatter.string(from: date)
        
        let timeZone = TimeZone.autoupdatingCurrent
        let seconds:Double = Double(timeZone.secondsFromGMT(for: dateFormatter.date(from: UTCDate)!))
        
        return Date(timeInterval: seconds, since: dateFormatter.date(from: UTCDate)!).timeIntervalSince1970
        
    }
    
    public func getTimeStampWithDateTime()  -> TimeInterval
    {
        let date = Date();
        
        let dateFormatter = DateFormatter()
        
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = DateFormatter.Style.long //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        
        let UTCDate = dateFormatter.string(from: date)
        
        let timeZone = TimeZone.autoupdatingCurrent
        let seconds:Double = Double(timeZone.secondsFromGMT(for: dateFormatter.date(from: UTCDate)!))
        
        return Date(timeInterval: seconds, since: dateFormatter.date(from: UTCDate)!).timeIntervalSince1970
    }
    
    func initializeDateWithTime(_ hrs:Int,minutes:Int) -> TimeInterval{
        
        let date = Date();
        
        let dateFormatter = DateFormatter()
        
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        
        let UTCDate = dateFormatter.string(from: date)
        
        let today = dateFormatter.date(from: UTCDate)
        
        let gregorian:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var dateComponents = (gregorian as NSCalendar).components([.year, .month, .day], from: today!)
        
        dateComponents.hour = hrs;
        dateComponents.minute = minutes;
        let dateFormatter2 = DateFormatter()
        
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter2.timeStyle = DateFormatter.Style.long //Set time style
        dateFormatter2.dateStyle = DateFormatter.Style.long //Set date style
        
        let todayAtX = gregorian.date(from: dateComponents)
        
        let UTCDate2 = dateFormatter2.string(from: todayAtX!)
        let timeZone = TimeZone.autoupdatingCurrent
        let seconds:Double = Double(timeZone.secondsFromGMT(for: dateFormatter2.date(from: UTCDate2)!))
        
        return Date(timeInterval: seconds, since: dateFormatter2.date(from: UTCDate2)!).timeIntervalSince1970
        
    }
    
    
    public func getDateFromTimeStampe(_ formate : String , timestampe : String) -> String?
    {
        let dateFormater : DateFormatter = DateFormatter()
        dateFormater .dateFormat = formate
        
        let dateString = dateFormater .string(from: Date(timeIntervalSince1970: Double(timestampe)!))
        return dateString
    }
    
    public func setDateFromTimeStampe(_ formate : String , timestampe : Double) -> String?
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = Date(timeIntervalSince1970: timestampe)
        
        let timeZone = TimeZone.autoupdatingCurrent
        let UTCDate = dateFormatter.string(from: date)
        
        let seconds:Double = Double(timeZone.secondsFromGMT(for: dateFormatter.date(from: UTCDate)!))
        
        let date2 = Date(timeInterval: -seconds, since: dateFormatter.date(from: UTCDate)!).timeIntervalSince1970
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: date2))
    }
    
    //  Get Week day from date
    public var weekDay:Int {
        return (Calendar.current as NSCalendar).component(.weekday, from: self)
    }
    
    //  Get Week index of month from date
    public var weekOfMonth : Int {
        return (Calendar.current as NSCalendar).component(.weekOfMonth, from: self)
    }
    
    //  Get Week day name from date
    public var weekDayName : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    
    //  Get Month name from date
    public var monthName : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    //  Get Month index from date
    public var month: Int {
        return (Calendar.current as NSCalendar).component(.month, from: self)
    }
    
    //  Get Day index from date
    public var day: Int {
        return (Calendar.current as NSCalendar).component(.day, from: self)
    }
    
    //  Get Year index from date
    public var year: Int {
        return (Calendar.current as NSCalendar).component(.year, from: self)
    }
    
    //  Get Hour and Minute from date
    public func getHourAndMinute() -> (hour : Int, minute : Int) {
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.hour, .minute], from: self)
        return (comp.hour!, comp.minute!)
    }
    
    //  Get Total count of weeks in month from date
    public func weeksInMonth() -> Int?
    {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.firstWeekday = 2 // 2 == Monday
        
        // First monday in month:
        var comps = DateComponents()
        comps.month = self.month
        comps.year = self.year
        comps.weekday = calendar.firstWeekday
        comps.weekdayOrdinal = 1
        guard let first = calendar.date(from: comps)  else {
            return nil
        }
        
        // Last monday in month:
        comps.weekdayOrdinal = -1
        guard let last = calendar.date(from: comps)  else {
            return nil
        }
        
        // Difference in weeks:
        let weeks = (calendar as NSCalendar).components(.weekOfMonth, from: first, to: last, options: [])
        return weeks.weekOfMonth! + 1
    }
    
    //  Get Total count of week days in month from date
    public func weekDaysInMonth() -> Int?
    {
        guard 1...12 ~= month else { return nil }
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.weekday =  self.weekDay
        components.weekdayOrdinal = 1
        components.month = self.month
        components.year = self.year
        
        if let date = calendar.date(from: components)  {
            let firstDay = (calendar as NSCalendar).component(.day, from: date)
            let days = (calendar as NSCalendar).range(of: .day, in:.month, for:date).length
            return (days - firstDay) / 7 + 1
        }
        return nil
    }
    
    //  Get Total count of days in month from date
    public func daysInMonth() -> Int? {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).range(of: .day, in: .month, for: self).length
    }
    
    //  Get Time in AM / PM format
    public func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
    //  Get Time short (i.e 12 Mar) format
    public func getTimeInShortFormat() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }
    
    //  Get Time short (i.e 12 Mar, 2016) format
    public func getTimeInFullFormat() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: self)
    }
    
    //  Get Time standard (i.e 2016-03-12) format
    public func formateBirthDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    //  Check date is after date
    public func afterDate(_ date : Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }
    
    //  Check date is before date
    public func beforDate(_ date : Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }
    
    //  Check date is equal date
    public func equalDate(_ date : Date) -> Bool {
        return (self == date)
    }
    
    //  Get days difference between dates
    public func daysInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference/86400)
        return Int(difference)
    }
    
    //  Get hours difference between dates
    public func hoursInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference/3600)
        return Int(difference)
    }
    
    //  Get minutes difference between dates
    public func minutesInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference/60)
        return Int(difference)
    }
    
    //  Get seconds difference between dates
    public func secondsInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference)
        return Int(difference)
    }
    
    //  Get time difference between dates
    public func getDifferenceBetweenDates() -> String {
        let interval = self.timeIntervalSinceNow
        let year : Int = Int(interval) / 31536000
        var finalString = "'"
        if year >= 1 {
            if year == 1 {
                finalString += "1 year : "
            }
            else {
                finalString += "\(year) years : "
            }
        }
        let remainAfterYear = Int( interval) % 31536000
        let month = remainAfterYear / 2592000
        if month >= 1 {
            if month == 1 {
                finalString += "1 month : "
            }
            else {
                finalString += "\(month) months : "
            }
        }
        let remainAfterMonth =  remainAfterYear % 2592000
        let day = remainAfterMonth / 86400
        if day >= 1 {
            if day == 1 {
                finalString += "1 day : "
            }
            else {
                finalString += "\(day) days : "
            }
        }
        let remainAfterDay =  remainAfterMonth % 86400
        let hour = remainAfterDay / 3600
        if hour >= 1 {
            finalString += "\(hour)h : "
        }
        let remainAfterHour = remainAfterDay % 3600
        let minute = remainAfterHour / 60
        if minute >= 1 {
            finalString += "\(minute)m : "
        }
        let remainAfterMinute = remainAfterHour % 60
        let second = remainAfterMinute / 60
        if second >= 1 {
            finalString += "\(second)s "
        }
        
        return finalString
    }
}

