//
//  TodoListCell.swift
//
//
//  Created by 박세라 on 4/1/24.
//

import Foundation
import ReactorKit
import Model

public class TodoListCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Property
    public let initialState: Todo
    
    public init(state: Todo) {
        self.initialState = state
    }
}
