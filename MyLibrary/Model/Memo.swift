//
//  Plan.swift
//
//
//  Created by 박세라 on 5/10/24.
//

import Foundation

public struct Memo {
    
    public var memo_id: Int32
    public var content: String
    
    public init(memo_id: Int32, content: String) {
        self.memo_id = memo_id
        self.content = content
    }
}
