//
//  BookTitleCellReactor.swift
//  
//
//  Created by 박세라 on 5/23/24.
//

import Foundation
import ReactorKit
import Model

public class BookTitleCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Property
    public let initialState: Book
    
    public init(state: Book) {
        self.initialState = state
    }
}
