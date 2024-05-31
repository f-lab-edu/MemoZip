//
//  Plan.swift
//
//
//  Created by 박세라 on 5/10/24.
//

import Foundation

public struct Memo {
    
    public var memoId: Int32
    public var content: String
    
    public init(memoId: Int32, content: String) {
        self.memoId = memoId
        self.content = content
    }
}
