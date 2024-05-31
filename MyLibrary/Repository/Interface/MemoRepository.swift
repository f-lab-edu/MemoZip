//
//  MemoRepository.swift
//
//
//  Created by 박세라 on 5/10/24.
//

import Model
import RxSwift

public protocol MemoRepository {
    func fetch() -> Observable<[Memo]>
    func create(content: String) -> Bool
    func update()
    func delete(with memoId: Int32) -> Bool
}
