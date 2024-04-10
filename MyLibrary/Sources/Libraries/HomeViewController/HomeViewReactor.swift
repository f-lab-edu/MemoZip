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

public class HomeViewReactor: Reactor {
    
    // MARK: - Constants
    public enum CellType {
        case defaultCell(String, String)
    }
    
    // MARK: - Property
    public let initialState: State
    
    // MARK: - Constants
    public enum Action {
        case initiateTodo
        case initiatePlan
        case cellSelected(IndexPath)
    }
    
    public enum Mutation {
        case updateTodo(todos: [Todo])
        case updatePlan(plans: [Plan])
        case setSelectedIndexPath(IndexPath?)
    }
    
    public struct State {
         var selectedIndexPath: IndexPath?
         var sections: [HomeSection]
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
        case .initiateTodo:
            return self.todoRepository.fetch().map { .updateTodo(todos: $0) }
        case .initiatePlan:
            return self.planRepository.fetch().map { .updatePlan(plans: $0)}
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
        case let .updateTodo(todos):
            // TODO: Update newState
            var todoCells = [HomeSectionItem]()
            for todo in todos {
                todoCells.append(HomeSectionItem.defaultCell(TodoListCellReactor(state: todo)))
            }
            
            let todoList = HomeSection(header: "Todo", items: todoCells)
            
            sections.append(todoList)
            
            newState.sections = sections
    
            print(todos)
        case let .updatePlan(plans):
            
            var planCells = [HomeSectionItem]()
            for plan in plans {
                planCells.append(HomeSectionItem.planCell(PlanListCellReactor(state: plan)))
            }
            
            let planList = HomeSection(header: "Plan", items: planCells)
            
            sections.append(planList)
            
            newState.sections = sections
            print(plans)
        case .setSelectedIndexPath(let indexPath):
            newState.selectedIndexPath = indexPath
        
        }
        return newState
    }
}
