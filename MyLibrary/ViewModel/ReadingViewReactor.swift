//
//  ReadingViewReactor.swift
//
//
//  Created by 박세라 on 5/23/24.
//

import Foundation
import ReactorKit
import Repository
import RxSwift
import Model

public class ReadingViewReactor: Reactor {
    
    // MARK: - Property
    public let initialState: State
    private let bookRepository: BookRepository
    private var sections = [ReadingSection]()
    
    // MARK: - Constant
    public enum Action {
        case initiate
    }
    
    public enum Mutation {
        case setSections([ReadingSection])
    }
    
    public struct State {
        public var sections: [ReadingSection] = []
    }
    
    public init(bookRepository: BookRepository){
        self.bookRepository = bookRepository
        
        self.initialState = State()
    }
    
    // MARK: Function
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initiate:
            let sections: [ReadingSection] = [
                ReadingSection(header: "Books", items: [
                    .titleCell,
                    .dateCell,
                    .pageCell,
                    .colorCell,
                    .progressTypeCell
                ])
            ]
            return Observable.just(.setSections(sections))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
            return newState
        }
        
    }
}
