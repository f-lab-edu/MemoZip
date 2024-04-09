import Model
import RxSwift

public protocol TodoRepository {
    func fetch() -> Observable<[Todo]>
    func create()
    func update()
    func delete()
}
