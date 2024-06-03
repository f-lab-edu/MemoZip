//
//  Book.swift
//  
//
//  Created by 박세라 on 5/23/24.
//

import Foundation

public struct Book {
    public let bookId: Int32
    public var title: String
    public var startAt: String?
    public var endAt: String?
    public var startPage: Int? = 0
    public var endPage: Int? = 0
    public var colorCode: String
    public var isDisplayDday: Bool?
    
    public init(
        bookId: Int32,
        title: String = "제목없음",
        startAt: String? = Date().formattedDate(from: Date(), to: "yyyy.MM.dd"),
        endAt: String? = Date().formattedDate(from: Date(), to: "yyyy.MM.dd"),
        startPage: Int? = 0, endPage: Int? = 0,
        colorCode: String = "000000",
        isDisplayDday: Bool? = true
    ) {
        self.bookId = bookId
        self.title = title
        self.startAt = startAt
        self.endAt = endAt
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
