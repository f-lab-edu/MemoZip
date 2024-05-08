import Repository
import RepositoryImp
import UIKit
import ViewModel
import View

typealias AppRouting =
    HomeRouting

final class AppComponent: AppRouting {
    private let todoRepository: TodoRepository
    private let planRepository: PlanRepository

    init() {
        self.todoRepository = TodoRepositoryImp()
        self.planRepository = PlanRepositoryImp()
    }

    func homeViewController() -> UIViewController {
        let reactor = HomeViewReactor(
            todoRepository: self.todoRepository,
            planRepository: self.planRepository
        )
        return HomeViewController(reactor: reactor, routing: self)
    }
    
    func addMemoViewController(messageHandler: @escaping (String) -> ()) -> UIViewController {
        let addMemoVC = AddMemoViewController()
        addMemoVC.messageHandler = messageHandler
        return addMemoVC
    }
}
