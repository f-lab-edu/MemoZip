//
//  MemoRepositoryImp.swift
//
//
//  Created by 박세라 on 5/10/24.
//

import Model
import Repository

import RxSwift
import FMDB

public class MemoRepositoryImp: MemoRepository {
    
    public typealias MemoRecord = (String)

    public func fetch() -> Observable<[Memo]> {
        return .just([
            Memo(content: "첫번째 메모"),
            Memo(content: "두번째 메모"),
            Memo(content: "세번째 메모"),
        ])
    }

    public func create(content: String) -> Bool {
        return true
    }

    public func update() {}

    public func delete() {}
}
