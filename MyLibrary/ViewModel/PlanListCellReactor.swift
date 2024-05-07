//
//  PlanListCellReactor.swift
//
//
//  Created by 박세라 on 4/3/24.
//

import Foundation
import ReactorKit
import Model

public class PlanListCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Property
    public let initialState: Plan
    
    public init(state: Plan) {
        self.initialState = state
    }
}
