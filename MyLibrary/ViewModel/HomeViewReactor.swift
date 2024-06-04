//
//  HomeViewReactor.swift
//
//
//  Created by 박세라 on 3/31/24.
//

import Foundation
import ReactorKit
import RxSwift

import Common
import Model
import Repository


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
        case openBookView(bookViewOpenType: BookViewOpenType)
        case addMemo(String)
        case addBook(Book)
        case updateBook(Book)
        case deleteMemo(IndexPath)
    }
    
    public enum Mutation {
        case update(todos: [Todo], memos: [Memo], books: [Book], selectedPlanType: PlanType? = nil)
        case showBook(BookViewOpenType)
        case updateBook(BookViewOpenType)
        case saveMemo(String)
    }
    
    public struct State {
        public var todos: [Todo] = []
        public var memos: [Memo] = []
        public var books: [Book] = []
        public var sections: [HomeSection]
        public var selectedPlanType: PlanType = .memo
        public var memonContent: String?
        public var bookView: BookViewOpenType?
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
            sections: [HomeSection]()
        )
    }
    
    // MARK: - func
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initiate:
            return self.fetchAll()
        case .planTypeSelected(let planType):
            return self.fetchAll(with: planType)
        case .openBookView(let bookViewType):
            switch bookViewType.type {
            case .create, .delete: // FIXME: 나중에 수정
                return Observable.just(Mutation.showBook(BookViewOpenType(type: .create)))
            case .read:
                return Observable.just(Mutation.updateBook(BookViewOpenType(type: .read, book: bookViewType.book!)))
            case .update:
                return Observable.just(Mutation.updateBook(BookViewOpenType(type: .update, book: bookViewType.book!)))
            }
        case .addMemo(let memo):
            guard self.memoRepository.create(content: memo) else { return Observable.just(Mutation.saveMemo(""))}
            return Observable.concat(
                Observable.just(Mutation.saveMemo(memo)),
                self.fetchAll(with: .memo)
            )
        case .updateBook(let book):
            _ = self.bookRepository.update(book: book)
            return self.fetchAll(with: .book)
        case .addBook(let book):
            _ = self.bookRepository.create(book: book)
            return self.fetchAll(with: .book)
        case .deleteMemo(let indexPath):
            var targetMemo: Memo?
            memoRepository.fetch()
                .subscribe(onNext: { memos in
                    targetMemo = memos[indexPath.row]
                }).dispose()
            
            if let deleteId = targetMemo?.memoID {
                _ = memoRepository.delete(with: deleteId)
            }
            return self.fetchAll(with: .memo)
        }
    }
    
    private func fetchAll(with type: PlanType? = nil) -> Observable<Mutation> {
        return Observable.zip(todoRepository.fetch(), memoRepository.fetch(), bookRepository.fetch())
            .map { todos, memos, books in
                Mutation.update(todos: todos, memos: memos, books: books, selectedPlanType: type)
            }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .update(todos, memos, books, planType):
            newState.todos = todos
            newState.memos = memos
            newState.books = books
            if let planType = planType {
                newState.selectedPlanType = planType
            }
            let plans: [Plan]
            switch newState.selectedPlanType {
            case .memo: plans = newState.memos.map { Plan(memo: $0) }
            case .book: plans = newState.books.map { Plan(book: $0) }
            }
            var sections = [HomeSection]()
            
            let todoCells = todos.map {
                HomeSectionItem.defaultCell(TodoListCellReactor(state: $0))
            }
            let planCells = plans.map { plan -> HomeSectionItem in
                switch plan {
                case .memo(let memo):
                    // Memo 객체의 정보를 사용
                    return HomeSectionItem.memoCell(MemoListCellReactor(state: memo))
                case .book(let book):
                    // Book 객체의 정보를 사용
                    return HomeSectionItem.bookCell(BookListCellReactor(state: book))
                }
            }
            
            // TODO: Category도 Model화 작업 예정.
            var categoryCells = [HomeSectionItem.planTypesCell(newState.selectedPlanType)]
            
            categoryCells.append(contentsOf: planCells)
            
            let todoList = HomeSection(header: "Todo", items: todoCells)
            let planList = HomeSection(header: "Plan", items: categoryCells)
            
            sections.append(todoList)
            sections.append(planList)
            
            newState.sections = sections
        case .updateBook(let bookView):
            newState.bookView = bookView
        case .showBook(let bookView):
            newState.bookView = bookView
        case .saveMemo(let memo):
            newState.memonContent = memo
        }
        return newState
    }
}

public struct BookViewOpenType {
    public var type: OpenViewType
    public var book: Book? = nil
    
    public init(type: OpenViewType, book: Book? = nil) {
        self.type = type
        self.book = book
    }
}
