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
            Plan(book: Book(bookId: 3309, title: "Clean Code", colorCode: "FFDAB9")),
            Plan(book: Book(bookId: 3304, title: "개미", colorCode: "E6E6FA"))
        ])
    }

    public func create() {}

    public func update() {}

    public func delete() {}
}
