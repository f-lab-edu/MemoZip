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
            Plan(title: "Clean Code"),
            Plan(title: "개미"),
            Plan(title: "꿈꾸는 다락방"),
        ])
    }

    public func create() {}

    public func update() {}

    public func delete() {}
}
