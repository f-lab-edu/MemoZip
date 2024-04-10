//
//  PlanRepository.swift
//
//
//  Created by 박세라 on 4/9/24.
//

import Model
import RxSwift

public protocol PlanRepository {
    func fetch() -> Observable<[Plan]>
    func create()
    func update()
    func delete()
}
