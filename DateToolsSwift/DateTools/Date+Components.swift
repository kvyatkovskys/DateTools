//
//  Date+Components.swift
//  DateToolsTests
//
//  Created by Matthew York on 8/26/16.
//  Copyright © 2016 Matthew York. All rights reserved.
//

import Foundation

/**
 *  Extends the Date class by adding convenient accessors of calendar
 *  components. Meta information about the date is also accessible via
 *  several computed Bools.
 */
public extension Date {

    /**
     *  Convenient accessor of the date's `Calendar` components.
     *
     *  - parameter component: The calendar component to access from the date
     *
     *  - returns: The value of the component
     *
     */
    func component(_ component: Calendar.Component) -> Int {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.component(component, from: self)
    }

    /**
     *  Convenient accessor of the date's `Calendar` components ordinality.
     *
     *  - parameter smaller: The smaller calendar component to access from the date
     *  - parameter larger: The larger calendar component to access from the date
     *
     *  - returns: The ordinal number of a smaller calendar component within a specified larger calendar component
     *
     */
    func ordinality(of smaller: Calendar.Component, in larger: Calendar.Component) -> Int? {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.ordinality(of: smaller, in: larger, for: self)
    }

    /**
     *  Use calendar components to determine how many units of a smaller component are inside 1 larger unit.
     *
     *  Ex. If used on a date in the month of February in a leap year (regardless of the day), the method would
     *  return 29 days.
     *
     *  - parameter smaller: The smaller calendar component to access from the date
     *  - parameter larger: The larger calendar component to access from the date
     *
     *  - returns: The number of smaller units required to equal in 1 larger unit, given the date called on
     *
     */
    func unit(of smaller: Calendar.Component, in larger: Calendar.Component) -> Int? {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        var units = 1
        var unitRange: Range<Int>?
        if larger.hashValue < smaller.hashValue {
            for x in larger.hashValue..<smaller.hashValue {

                var stepLarger: Calendar.Component
                var stepSmaller: Calendar.Component

                switch(x) {
                case 0:
                    stepLarger = Calendar.Component.era
                    stepSmaller = Calendar.Component.year
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                case 1:
                    if smaller.hashValue > 2 {
                        break
                    } else {
                        stepLarger = Calendar.Component.year
                        stepSmaller = Calendar.Component.month
                        unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    }
                    break
                case 2:
                    if larger.hashValue < 2 {
                        if self.isInLeapYear {
                            unitRange = Range.init(uncheckedBounds: (lower: 0, upper: 366))
                        } else {
                            unitRange = Range.init(uncheckedBounds: (lower: 0, upper: 365))
                        }
                    } else {
                        stepLarger = Calendar.Component.month
                        stepSmaller = Calendar.Component.day
                        unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    }
                    break
                case 3:
                    stepLarger = Calendar.Component.day
                    stepSmaller = Calendar.Component.hour
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                case 4:
                    stepLarger = Calendar.Component.hour
                    stepSmaller = Calendar.Component.minute
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                case 5:
                    stepLarger = Calendar.Component.minute
                    stepSmaller = Calendar.Component.second
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                default:
                    return nil
                }

                if unitRange?.count != nil {
                    units *= (unitRange?.count)!
                }
            }
            return units
        }
        return nil
    }

    // MARK: - Components

    /**
     *  Convenience getter for the date's `era` component
     */
    var era: Int {
        return component(.era)
    }

    /**
     *  Convenience getter for the date's `year` component
     */
    var year: Int {
        return component(.year)
    }

    /**
     *  Convenience getter for the date's `month` component
     */
    var month: Int {
        return component(.month)
    }

    /**
     *  Convenience getter for the date's `week` component
     */
    var week: Int {
        return component(.weekday)
    }

    /**
     *  Convenience getter for the date's `day` component
     */
    var day: Int {
        return component(.day)
    }

    /**
     *  Convenience getter for the date's `hour` component
     */
    var hour: Int {
        return component(.hour)
    }

    /**
     *  Convenience getter for the date's `minute` component
     */
    var minute: Int {
        return component(.minute)
    }

    /**
     *  Convenience getter for the date's `second` component
     */
    var second: Int {
        return component(.second)
    }

    /**
     *  Convenience getter for the date's `weekday` component
     */
    var weekday: Int {
        return component(.weekday)
    }

    /**
     *  Convenience getter for the date's `weekdayOrdinal` component
     */
    var weekdayOrdinal: Int {
        return component(.weekdayOrdinal)
    }

    /**
     *  Convenience getter for the date's `quarter` component
     */
    var quarter: Int {
        return component(.quarter)
    }

    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    var weekOfMonth: Int {
        return component(.weekOfMonth)
    }

    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    var weekOfYear: Int {
        return component(.weekOfYear)
    }

    /**
     *  Convenience getter for the date's `yearForWeekOfYear` component
     */
    var yearForWeekOfYear: Int {
        return component(.yearForWeekOfYear)
    }

    /**
     *  Convenience getter for the date's `daysInMonth` component
     */
    var daysInMonth: Int {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let days = calendar.range(of: .day, in: .month, for: self)
        return days!.count
    }

    // MARK: - Set Components

    /**
     *  Convenience setter for the date's `year` component
     */
    mutating func year(_ year: Int) {
        self = Date.init(year: year, month: self.month, day: self.day, hour: self.hour, minute: self.minute, second: self.second)
    }

    /**
     *  Convenience setter for the date's `month` component
     */
    mutating func month(_ month: Int) {
        self = Date.init(year: self.year, month: month, day: self.day, hour: self.hour, minute: self.minute, second: self.second)
    }

    /**
     *  Convenience setter for the date's `day` component
     */
    mutating func day(_ day: Int) {
        self = Date.init(year: self.year, month: self.month, day: day, hour: self.hour, minute: self.minute, second: self.second)
    }

    /**
     *  Convenience setter for the date's `hour` component
     */
    mutating func hour(_ hour: Int) {
        self = Date.init(year: self.year, month: self.month, day: self.day, hour: hour, minute: self.minute, second: self.second)
    }

    /**
     *  Convenience setter for the date's `minute` component
     */
    mutating func minute(_ minute: Int) {
        self = Date.init(year: self.year, month: self.month, day: self.day, hour: self.hour, minute: minute, second: self.second)
    }

    /**
     *  Convenience setter for the date's `second` component
     */
    mutating func second(_ second: Int) {
        self = Date.init(year: self.year, month: self.month, day: self.day, hour: self.hour, minute: self.minute, second: second)
    }

    // MARK: - Bools

    /**
     *  Determine if date is in a leap year
     */
    var isInLeapYear: Bool {
        let yearComponent = component(.year)

        if yearComponent % 400 == 0 {
            return true
        }
        if yearComponent % 100 == 0 {
            return false
        }
        if yearComponent % 4 == 0 {
            return true
        }
        return false
    }

    /**
     *  Determine if date is within the current day
     */
    var isToday: Bool {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.isDateInToday(self)
    }

    /**
     *  Determine if date is within the day tomorrow
     */
    var isTomorrow: Bool {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.isDateInTomorrow(self)
    }

    /**
     *  Determine if date is within yesterday
     */
    var isYesterday: Bool {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.isDateInYesterday(self)
    }

    /**
     *  Determine if date is in a weekend
     */
    var isWeekend: Bool {
        if weekday == 7 || weekday == 1 {
            return true
        }
        return false
    }

    /**
     *  First day of the month
     */
    var firstDayOfTheMonth: Date? {
        return Calendar.current.dateComponents([.calendar, .year,.month], from: self).date
    }

    var lastDayOfMonth: Date? {
        guard let date = self.firstDayOfTheMonth else { return nil }
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: date)
    }

}
