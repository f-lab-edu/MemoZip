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
        
        // FIXME: Dummy Data 수정 예정
        let defaultCell = HomeSectionItem.defaultCell(TodoListCellReactor(state: Todo(title: "물 3잔 마시기")))
        
        let defaultCell2 = HomeSectionItem.defaultCell(TodoListCellReactor(state: Todo(title: "OO기업 자소서 쓰기", subTitle: "오늘까지", isComplete: true)))
        
        let defaultsection = HomeSection.first([defaultCell, defaultCell2])
        
        return [defaultsection]
    }
    
}
