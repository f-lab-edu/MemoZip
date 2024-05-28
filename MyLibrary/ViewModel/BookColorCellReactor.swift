//
//  BookColorCellReactor.swift
//
//
//  Created by 박세라 on 5/27/24.
//

import Foundation
import ReactorKit
import Model

public class BookColorCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Property
    public let initialState: Book
    
    public init(state: Book) {
        self.initialState = state
    }
}
