//
//  HomeViewReactor.swift
//
//
//  Created by 박세라 on 3/31/24.
//

import Foundation
import ReactorKit
import RxSwift


public class HomeViewReactor: Reactor {
    
    // MARK: - Constants
    public enum CellType {
        case defaultCell(String, String)
    }
    
    // MARK: - Property
    public let initialState: State
    
    // MARK: - Constants
    public enum Action {
        case cellSelected(IndexPath)
    }
    
    public enum Mutation {
        case setSelectedIndexPath(IndexPath?)
    }
    
    public struct State {
         var selectedIndexPath: IndexPath?
         var sections: [HomeSection]
    }
    
    public init() {
         self.initialState = State(
         sections: HomeViewReactor.configSections()
         )
    }
    
    // MARK: - func
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cellSelected(let indexPath):
            return Observable.concat([
                Observable.just(Mutation.setSelectedIndexPath(indexPath)),
                Observable.just(Mutation.setSelectedIndexPath(nil))
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSelectedIndexPath(let indexPath):
            newState.selectedIndexPath = indexPath
        }
        return newState
    }
    
   
     static func configSections() -> [HomeSection] {
     
     let defaultCell = TableViewCellSectionItem.defaultCell(TodoListCellReactor(state: Todo(title: "세상에 나쁜 아라찌는 없다.", subTitle: "아라찌")))
     
     let defaultCell2 = TableViewCellSectionItem.defaultCell(TodoListCellReactor(state: Todo(title: "웃어서 행복한거다.", subTitle: "노홍철")))
     
     let defaultsection = HomeSection.first([defaultCell, defaultCell2])
     
     return [defaultsection]
     }
    
}
