//
//  PlanRepositoryImp.swift
//
//
//  Created by 박세라 on 4/9/24.
//

import Model
import Repository
import RxSwift

public class PlanRepositoryImp: PlanRepository {
    public init() {}

    public func fetch() -> Observable<[Plan]> {
        return .just([
            Plan(book: Book(title: "Clean Code", colorCode: "FFDAB9")),
            Plan(book: Book(title: "개미", colorCode: "E6E6FA"))
            //Plan(memo: Memo(memo_id: 0, content: "메모입니다."))
        ])
    }

    public func create() {}

    public func update() {}

    public func delete() {}
}
