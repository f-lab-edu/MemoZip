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
    
    public lazy var fmdb: FMDatabase! = {
        let fileManager = FileManager.default
        
        let docPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let dbPath = docPath!.appendingPathComponent("memo_db.sqlite").path
        
        if fileManager.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "memo_db", ofType: "sqlite")
            try! fileManager.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    public init() {
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
    }

    public func fetch() -> Observable<[Memo]> {
        
        var memoList = [Memo]()
        
        do {
            let sql = """
              SELECT content
              FROM memo
            """
            
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
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
            
            try self.fmdb.executeUpdate(sql, values: [content])
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
        
    }

    public func update() {}

    public func delete() {}
}
