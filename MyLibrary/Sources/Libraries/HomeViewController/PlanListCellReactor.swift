//
//  PlanListCellReactor.swift
//
//
//  Created by 박세라 on 4/3/24.
//

import Foundation
import ReactorKit

class PlanListCellReactor: Reactor {
    
    typealias Action = NoAction
    
    // MARK: - Property
    let initialState: Plan
    
    init(state: Plan) {
        self.initialState = state
    }
}
