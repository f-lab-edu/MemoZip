//
//  AddReadingViewCellReactor.swift
//
//
//  Created by 박세라 on 5/29/24.
//

import Foundation
import ReactorKit
import RxSwift

import Model
import Repository


final class AddReadingViewCellReactor: Reactor {
    enum Action {
        case initiate
        case updateTitle(String)
        case updateDate(Date)
        case updatePages(startPage: Int, endPage: Int)
        case updateColor(String)
    }
    
    enum Mutation {
        case setTitle(String)
        case setDate(Date)
        case setPages(startPage: Int, endPage: Int)
        case setColor(String)
    }
    
    struct State {
        var title: String = ""
        var date: Date = Date()
        var startPage: Int = 0
        var endPage: Int = 0
        var color: String = "#F5EB33"
        var sections: [ReadingSection] = []
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initiate:
            return .empty()
        case let .updateTitle(title):
            return .just(.setTitle(title))
        case let .updateDate(date):
            return .just(.setDate(date))
        case let .updatePages(startPage, endPage):
            return .just(.setPages(startPage: startPage, endPage: endPage))
        case let .updateColor(color):
            return .just(.setColor(color))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setTitle(title):
            newState.title = title
        case let .setDate(date):
            newState.date = date
        case let .setPages(startPage, endPage):
            newState.startPage = startPage
            newState.endPage = endPage
        case let .setColor(color):
            newState.color = color
        }
        return newState
    }
}
