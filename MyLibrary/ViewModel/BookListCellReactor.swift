//
//  BookListCellReactor.swift
//
//
//  Created by 박세라 on 4/3/24.
//

import Foundation
import ReactorKit
import Model

public class BookListCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Property
    public let initialState: Book
    
    public init(state: Book) {
        self.initialState = state
    }
}
