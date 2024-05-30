//
//  Book.swift
//  
//
//  Created by 박세라 on 5/23/24.
//

import Foundation

public struct Book {
    public var title: String
    public var startDt: String?
    public var endDt: String?
    public var startPage: Int?
    public var endPage: Int?
    public var colorCode: String
    public var isDisplayDday: Bool?
    
    public init(title: String = "제목없음", 
                startDt: String? = Date().formattedDate(from: Date(), to: "yyyy.MM.dd"),
                endDt: String? = Date().formattedDate(from: Date(), to: "yyyy.MM.dd"),
                startPage: Int? = 0, endPage: Int? = 0,
                colorCode: String = "000000",
                isDisplayDday: Bool? = true) {
        self.title = title
        self.startDt = startDt
        self.endDt = endDt
        self.startPage = startPage
        self.endPage = endPage
        self.colorCode = colorCode
        self.isDisplayDday = isDisplayDday
    }
}

public enum ProgressType: Int, CaseIterable {
    case d_day
    case page
}

extension Date {
    public func formattedDate(from date: Date, to format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
