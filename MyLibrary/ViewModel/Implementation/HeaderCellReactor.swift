//
//  HeaderCellReactor.swift
//
//
//  Created by 박세라 on 4/2/24.
//


import Foundation
import ReactorKit
import Model

public class HeaderCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Property
    public let initialState: Title
    
    public init(state: Title) {
        self.initialState = state
    }
}
