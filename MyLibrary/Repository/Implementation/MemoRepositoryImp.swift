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
    
    private let dbManger = DBManger()
    
    public init() {}

    public func fetch() -> Observable<[Memo]> {
        
        var memoList = [Memo]()
        
        do {
            let sql = """
              SELECT memo_id, content
              FROM memo
            """
            
            let rs = try self.dbManger.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                let memoId = rs.int(forColumn: "memo_id")
                let memoContent = rs.string(forColumn: "content")
                memoList.append(Memo(memoId: memoId, content: memoContent!))
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
            
            try self.dbManger.fmdb.executeUpdate(sql, values: [content])
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
        
    }

    public func update() {}

    public func delete(with memoId: Int32) -> Bool { // memoId로 삭제
        print("😀 Delete Memo in Repo")
        do {
            let sql = """
            DELETE FROM memo
            WHERE memo_id = ?
            """
            try self.dbManger.fmdb.executeUpdate(sql, values: [memoId])
            return true
        } catch let error as NSError {
            print("Delete Error : \(error.localizedDescription)")
            return false
        }
    }
}
