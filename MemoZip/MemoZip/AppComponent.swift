import Repository
import RepositoryImp
import UIKit
import ViewModel
import ViewModelImp
import MyLibrary // => UI, View 혹은 Feature 같은 이름으로 변경 필요.

final class AppComponent {
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
        return HomeViewController(reactor: reactor)
    }
}
