//
//  BookRepository.swift
//
//
//  Created by 박세라 on 5/24/24.
//

import Model
import RxSwift

public protocol BookRepository {
    func fetch() -> Observable<[Book]>
    func create(content: String) -> Bool
    func update()
    func delete() -> Bool
}
