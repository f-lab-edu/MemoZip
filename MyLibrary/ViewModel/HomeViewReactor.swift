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
        case initiate
        case cellSelected(IndexPath)
        case moveToAddMemo(IndexPath)
        case addMemo(String)
    }
    
    public enum Mutation {
        case update(todos: [Todo], plans: [Memo])//[Plan])
        case setSelectedIndexPath(IndexPath?)
        case showAddViewController(IndexPath?)
        case saveMemo(String)
    }
    
    public struct State {
        public var selectedIndexPath: IndexPath?
        public var sections: [HomeSection]
        public var move: IndexPath?
        public var memonContent: String?
    }
    
    private let todoRepository: TodoRepository
    private let planRepository: PlanRepository
    private let memoRepository: MemoRepository
    
    private var sections = [HomeSection]()
    
    public init(todoRepository: TodoRepository, planRepository: PlanRepository, memoRepository: MemoRepository) {
        self.todoRepository = todoRepository
        self.planRepository = planRepository
        self.memoRepository = memoRepository
        
        self.initialState = State(
            sections: [HomeSection]()
        )
    }
    
    // MARK: - func
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initiate:
            return Observable.zip(todoRepository.fetch(), memoRepository.fetch())
                .map { todos, plans in
                    Mutation.update(todos: todos, plans: plans)
                }
        case .cellSelected(let indexPath):
            return Observable.concat([
                Observable.just(Mutation.setSelectedIndexPath(indexPath)),
                Observable.just(Mutation.setSelectedIndexPath(nil))
            ])
        case .moveToAddMemo(let indexPath):
            return Observable.concat([
                Observable.just(Mutation.showAddViewController(indexPath)),
                Observable.just(Mutation.showAddViewController(nil))
            ])
        case .addMemo(let memo):
            guard self.memoRepository.create(content: memo) else { return Observable.just(Mutation.saveMemo(""))}
            
            return Observable.concat(
                Observable.just(Mutation.saveMemo(memo)),
                Observable.zip(todoRepository.fetch(), memoRepository.fetch())
                    .map { todos, plans in
                        Mutation.update(todos: todos, plans: plans)
                    }
            )
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .update(todos, plans):
            // section 초기화
            sections = []
            
            let todoCells = todos.map {
                HomeSectionItem.defaultCell(TodoListCellReactor(state: $0))
            }
            let planCells = plans.map {
                //HomeSectionItem.planCell(PlanListCellReactor(state: $0))
                HomeSectionItem.memoCell(MemoListCellReactor(state:  $0))
            }
            
            // TODO: Category도 Model화 작업 예정.
            var categoryCells = [HomeSectionItem.categoryCell(["메모", "독서", "언어", "운동", "여행", "공부", "계획"])]
            
            categoryCells.append(contentsOf: planCells)
            
            let todoList = HomeSection(header: "Todo", items: todoCells)
            let planList = HomeSection(header: "Plan", items: categoryCells)
            
            sections.append(todoList)
            sections.append(planList)
            
            newState.sections = sections
            
        case .setSelectedIndexPath(let indexPath):
            newState.selectedIndexPath = indexPath
        case .showAddViewController(let indexPath):
            newState.move = indexPath
        case .saveMemo(let memo):
            newState.memonContent = memo
        }
        return newState
    }
}
