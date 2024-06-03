import Repository
import RepositoryImp
import UIKit
import ViewModel
import View
import Model
import Common

typealias AppRouting = HomeRouting

final class AppComponent: AppRouting {
    private let todoRepository: TodoRepository
    private let planRepository: PlanRepository
    private let memoRepository: MemoRepository
    private let bookRepository: BookRepository
    
    init() {
        self.todoRepository = TodoRepositoryImp()
        self.planRepository = PlanRepositoryImp()
        self.memoRepository = MemoRepositoryImp()
        self.bookRepository = BookRepositoryImp()
    }
    
    func homeViewController() -> UIViewController {
        let reactor = HomeViewReactor(
            todoRepository: self.todoRepository,
            planRepository: self.planRepository,
            memoRepository: self.memoRepository,
            bookRepository: self.bookRepository
        )
        return HomeViewController(reactor: reactor, routing: self)
    }
    
    func addMemoViewController(messageHandler: @escaping (String) -> ()) -> UIViewController {
        let addMemoVC = AddMemoViewController()
        addMemoVC.messageHandler = messageHandler
        return addMemoVC
    }
    
    func addReadingViewController(openViewType: OpenViewType, book: Book? = nil, dataHandler: @escaping (Book) -> ()) -> UICollectionViewController {
        let reactor = ReadingViewReactor(
            bookRepository: self.bookRepository
        )
        let addReadingVC = AddReadingViewController(reactor: reactor)
        addReadingVC.dataHandler = dataHandler
        addReadingVC.openViewType = openViewType
        if let book = book {
            addReadingVC.book = book
        }
        return addReadingVC
    }
}
