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
        case planTypeSelected(PlanType)
        case cellSelected(IndexPath)
        case moveToAddMemo(IndexPath)
        case addMemo(String)
        case addBook(Book)
        case deleteMemo(Int32)
    }
    
    public enum Mutation {
        case update(todos: [Todo], memos: [Memo], books: [Book], selectedPlanType: PlanType? = nil)
        case setSelectedIndexPath(IndexPath?)
        case showAddViewController(IndexPath?)
        case saveMemo(String)
    }
    
    public struct State {
        public var selectedIndexPath: IndexPath?
        public var todos: [Todo]
        public var memos: [Memo]
        public var books: [Book]
        public var selectedPlanType: PlanType = .memo
        public var move: IndexPath?
        public var memonContent: String?
    }
    
    private let todoRepository: TodoRepository
    private let planRepository: PlanRepository
    private let memoRepository: MemoRepository
    private let bookRepository: BookRepository
    
    public init(todoRepository: TodoRepository, planRepository: PlanRepository, memoRepository: MemoRepository, bookRepository: BookRepository) {
        self.todoRepository = todoRepository
        self.planRepository = planRepository
        self.memoRepository = memoRepository
        self.bookRepository = bookRepository
        
        self.initialState = State(
            todos: [],
            memos: [],
            books: []
        )
    }
    
    // MARK: - func
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initiate: // 초기화 시에는 memo만 load
            return Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
                .map { todos, memos, books in
                    Mutation.update(todos: todos, memos: memos, books: books)
                }
        case .planTypeSelected(let planType):
            return Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
                .map { todos, memos, books in
                    return Mutation.update(todos: todos, memos: memos, books: books, selectedPlanType: planType)
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
                Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
                    .map { todos, memos, books in
                        Mutation.update(todos: todos, memos: memos, books: books)
                    }
            )
        case .addBook(let book):
            guard self.bookRepository.create(book: book) else { 
                return Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
                    .map { todos, memos, books in
                        Mutation.update(todos: todos, memos: memos, books: books, selectedPlanType: .book)
                    }
            }
            return Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
                .map { todos, memos, books in
                    Mutation.update(todos: todos, memos: memos, books: books, selectedPlanType: .book)
                }
        case let .deleteMemo(memoID):
            guard memoRepository.delete(with: memoID) else {
                return Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
                    .map { todos, memos, books in
                        Mutation.update(todos: todos, memos: memos, books: books, selectedPlanType: .memo)
                    }
            }
            return Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
                .map { todos, memos, books in
                    Mutation.update(todos: todos, memos: memos, books: books, selectedPlanType: .memo)
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .update(todos, memos, books, planType):
            print("😀 Reactor update data")
            newState.todos = todos
            newState.memos = memos
            newState.books = books
            if let planType = planType {
                newState.selectedPlanType = planType
            }
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
