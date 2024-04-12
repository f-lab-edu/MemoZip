//
//  TodoListCell.swift
//
//
//  Created by 박세라 on 4/1/24.
//

import Foundation
import ReactorKit
import Model

class TodoListCellReactor: Reactor {
    
    typealias Action = NoAction
    
    // MARK: - Property
    let initialState: Todo
    
    init(state: Todo) {
        self.initialState = state
    }
}
