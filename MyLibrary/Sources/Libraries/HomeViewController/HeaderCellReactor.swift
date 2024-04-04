//
//  HeaderCellReactor.swift
//
//
//  Created by 박세라 on 4/2/24.
//


import Foundation
import ReactorKit

class HeaderCellReactor: Reactor {
    
    typealias Action = NoAction
    
    // MARK: - Property
    let initialState: Title
    
    init(state: Title) {
        self.initialState = state
    }
}
