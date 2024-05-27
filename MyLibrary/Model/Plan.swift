//
//  Plan.swift
//
//
//  Created by 박세라 on 4/3/24.
//

import Foundation

public enum Plan {
    case memo(Memo)
    case book(Book)
    
    // 생성자 정의
    public init(memo: Memo) {
        self = .memo(memo)
    }
    
    public init(book: Book) {
        self = .book(book)
    }
}

public enum PlanType: CaseIterable {
    case memo
    case book
}
