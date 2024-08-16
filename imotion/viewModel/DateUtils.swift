//
//  DateUtils.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/12.
//

import Foundation

class DateUtils {
    static let shared = DateUtils()
    private let hourMinuteFormatter: DateFormatter

    init() {
        hourMinuteFormatter = DateFormatter()
        hourMinuteFormatter.dateFormat = "HH:mm"  // Use "h:mm a" for 12-hour format
        hourMinuteFormatter.timeZone = TimeZone.current  // Adjust if needed
    }

    func formatHourMinute(date: Date) -> String {
        return hourMinuteFormatter.string(from: date)
    }
    
    func hourMinuteDifference(start_time: Date, end_time: Date) -> (hours: Int, minutes: Int) {
            let calendar = Calendar.current
            
            let components = calendar.dateComponents([.hour, .minute], from: start_time, to: end_time)
            
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
            
            return (hours, minutes)
    }
}

extension Date {
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
        return formatter.string(from: self)
    }
}
