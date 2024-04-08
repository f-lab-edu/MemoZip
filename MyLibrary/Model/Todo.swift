//
//  Todo.swift
//
//
//  Created by 박세라 on 4/1/24.
//

import Foundation

public struct Todo {
    
    public var title: String
    public var subTitle: String?
    public var isComplete: Bool? = false
    
    public init(title: String, subTitle: String? = nil, isComplete: Bool? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.isComplete = isComplete
    }
}
