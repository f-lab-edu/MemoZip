//
//  Todo.swift
//
//
//  Created by 박세라 on 4/1/24.
//

import Foundation

struct Todo {
    
    var title: String
    var subTitle: String?
    var isComplete: Bool? = false
    
    init(title: String, subTitle: String? = nil, isComplete: Bool? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.isComplete = isComplete
    }
}
