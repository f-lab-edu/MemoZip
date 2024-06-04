//
//  String+Extension.swift
//
//
//  Created by 박세라 on 6/4/24.
//

import Foundation

extension String {
    package func calculateDDay(format: String) -> Int? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let inputDate = dateFormatter.date(from: self) else {
            print("Invalid date format")
            return -1
        }
        
        let today = Date()
        
        // Check if the input date is in the past
        if inputDate < today {
            return -1
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: today, to: inputDate)
        
        return components.day ?? -1
    }
    
    package func daysBetween(_ endDateString: String, dateFormat: String = "yyyy.MM.dd") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        guard let startDate = dateFormatter.date(from: self),
              let endDate = dateFormatter.date(from: endDateString) else {
            print("Invalid date format")
            return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
    }
}
