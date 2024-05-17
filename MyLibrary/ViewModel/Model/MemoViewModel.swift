//
//  MemoViewModel.swift
//
//
//  Created by 박세라 on 5/17/24.
//

import Foundation
import RxSwift
import RxCocoa

import Model
import Repository

public class MemoViewModel: MemoRepository {
    
    private let dbManger = DBManger()
    
    // memos Observable
    private let memosSubject = BehaviorSubject<[Memo]>(value: [])
    var memos: Observable<[Memo]> {
        return memosSubject.asObservable()
    }

    // DisposeBag for RxSwift
    private let disposeBag = DisposeBag()

    //public func getDBManager() -> 
    
    public init() {
        
    }
    
    public func fetch() -> RxSwift.Observable<[Model.Memo]> {
        var memoList = [Memo]()
        
        do {
            let sql = """
              SELECT content
              FROM memo
            """
            
            let rs = try self.dbManger.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                let memoContent = rs.string(forColumn: "content")
                memoList.append(Memo(content: memoContent!))
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        return .just(memoList)
    }
    
    public func create(content: String) -> Bool {
        do {
            let sql = """
                INSERT INTO memo (content)
                VALUES ( ? )
                """
            
            try dbManger.fmdb.executeUpdate(sql, values: [content])
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }
    
    public func update() {
        print("update")
    }
    
    public func delete() {
        print("delete")
    }
    
}

