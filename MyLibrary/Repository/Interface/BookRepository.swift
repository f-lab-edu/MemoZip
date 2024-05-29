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
    func create(book: Book) -> Bool
    func update()
    func delete() -> Bool
}
