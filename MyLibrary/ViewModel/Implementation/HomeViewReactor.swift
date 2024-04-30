//
//  HomeViewReactor.swift
//
//
//  Created by 박세라 on 3/31/24.
//

import Foundation
import ReactorKit
import Repository
import RxSwift
import Model
import ViewModel

public class HomeViewReactor: Reactor {
    
    // MARK: - Constants
    public enum CellType {
        case defaultCell(String, String)
    }
    
    // MARK: - Property
    public let initialState: State
    
    // MARK: - Constants
    public enum Action {
        case initiate
        case cellSelected(IndexPath)
        case addItem(IndexPath)
    }
    
    public enum Mutation {
        case update(todos: [Todo], plans: [Plan])
        case setSelectedIndexPath(IndexPath?)
        case showAddViewController(IndexPath?)
    }
    
    public struct State {
        public var selectedIndexPath: IndexPath?
        public var sections: [HomeSection]
        public var move: IndexPath?
    }
    
    private let todoRepository: TodoRepository
    private let planRepository: PlanRepository
    private var sections = [HomeSection]()
    
    public init(todoRepository: TodoRepository, planRepository: PlanRepository) {
        self.todoRepository = todoRepository
        self.planRepository = planRepository
        
        self.initialState = State(
            sections: [HomeSection]()
        )
    }
    
    // MARK: - func
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initiate:
            return Observable.merge(self.todoRepository.fetch().map {.update(todos: $0, plans: [Plan]())}, self.planRepository.fetch().map {.update(todos: [Todo](), plans: $0)} )
        case .cellSelected(let indexPath):
            return Observable.concat([
                Observable.just(Mutation.setSelectedIndexPath(indexPath)),
                Observable.just(Mutation.setSelectedIndexPath(nil))
            ])
        case .addItem(let indexPath):
            return Observable.concat([
                Observable.just(Mutation.showAddViewController(indexPath)),
                Observable.just(Mutation.showAddViewController(nil))
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .update(todos, plans):
            let todoCells = todos.map {
                HomeSectionItem.defaultCell(TodoListCellReactor(state: $0))
            }
            var planCells = plans.map {
                HomeSectionItem.planCell(PlanListCellReactor(state: $0))
            }
            
            // TODO: Category도 Model화 작업 예정.
            var categoryCells = [HomeSectionItem.categoryCell(["독서", "언어", "운동", "여행", "공부", "계획"])]
            
            categoryCells.append(contentsOf: planCells)
            
            let todoList = HomeSection(header: "Todo", items: todoCells)
            let planList = HomeSection(header: "Plan", items: categoryCells)
            
            if !todos.isEmpty {
                sections.append(todoList)
            }
            
            if !plans.isEmpty {
                sections.append(planList)
            }
            newState.sections = sections
            
        case .setSelectedIndexPath(let indexPath):
            newState.selectedIndexPath = indexPath
        case .showAddViewController(let indexPath):
            newState.move = indexPath
        }
        return newState
    }
}
