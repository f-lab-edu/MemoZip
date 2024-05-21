//
//  MemoListCellReactor.swift
//  
//
//  Created by 박세라 on 5/21/24.
//

import Foundation
import ReactorKit
import Model

public class MemoListCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Property
    public let initialState: Memo
    
    public init(state: Memo) {
        self.initialState = state
    }
}
