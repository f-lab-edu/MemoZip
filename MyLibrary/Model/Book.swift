//
//  Book.swift
//  
//
//  Created by 박세라 on 5/23/24.
//

import Foundation

public struct Book {
    
    public var title: String
    public var startDt: Date?
    public var endDt: Date?
    public var page: Int?
    public var colorCode: String
    public var isDisplayDday: Bool?
    
    
    public init(title: String, startDt: Date? = Date(), endDt: Date? = nil, page: Int? = nil, colorCode: String, isDisplayDday: Bool? = false) {
        self.title = title
        self.startDt = startDt
        self.endDt = endDt
        self.page = page
        self.colorCode = colorCode
        self.isDisplayDday = isDisplayDday
    }
}
