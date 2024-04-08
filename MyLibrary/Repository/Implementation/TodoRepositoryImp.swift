import Model
import Repository
import RxSwift

public class TodoRepositoryImp: TodoRepository {
    public init() {}

    public func fetch() -> Observable<[Todo]> {
        return .just([
            Todo(title: "물 3잔 마시기"),
            Todo(title: "OO기업 자소서 쓰기", subTitle: "오늘까지", isComplete: true),
        ])
    }

    public func create() {}

    public func update() {}

    public func delete() {}
}
