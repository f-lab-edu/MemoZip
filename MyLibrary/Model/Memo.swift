//
//  Plan.swift
//
//
//  Created by 박세라 on 5/10/24.
//

import Foundation

public struct Memo {
    
    public let memoID: Int32
    public var content: String
    
    public init(memoID: Int32, content: String) {
        self.memoID = memoID
        self.content = content
    }
}
