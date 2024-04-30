//
//  HeaderCellReactor.swift
//
//
//  Created by 박세라 on 4/2/24.
//


import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import Model

public class HeaderCellReactor: Reactor {
    
    public enum Action {
        case initiate
        case buttonTapped
    }
    
    public enum Mutation {
        case update(String)
        case setButtonTapped(Bool)
    }
    
    public struct State {
        public var headerTitle: String = ""
        public var isButtonTapped: Bool = false
    }
    
    public let initialState: State
    
    public init(headerTitle: String) {
        self.initialState = State(
            headerTitle: headerTitle
            )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initiate:
            return .just(.update(initialState.headerTitle))
        case .buttonTapped:
            return .just(.setButtonTapped(true))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .update(let title):
            newState.headerTitle = title
        case .setButtonTapped(let isTapped):
            newState.isButtonTapped = isTapped
        }
        return newState
    }
}
