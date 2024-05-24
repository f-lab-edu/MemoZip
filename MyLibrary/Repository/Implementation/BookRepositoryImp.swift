//
//  BookRepositoryImp.swift
//  
//
//  Created by 박세라 on 5/24/24.
//

import Model
import Repository
import RxSwift

public class BookRepositoryImp: BookRepository {
    
    public typealias BookRecord = (String?)
    
    private let dbManger = DBManger()
    
    public init() {}
    
    public func fetch() -> Observable<[Book]> {
        /*
         var bookList = [Book]()
         
         do {
         let sql = """
         SELECT *
         FROM book
         """
         
         let rs = try self.dbManger.fmdb.executeQuery(sql, values: nil)
         
         while rs.next() {
         let memoContent = rs.string(forColumn: "content")
         bookList.append(Book(title: """, colorCode: """))
         }
         } catch let error as NSError {
         print("failed: \(error.localizedDescription)")
         }
         
        return .just(bookList)
         */
        return .just([
            Book(title: "Clean Code", colorCode: "FFD4A5"),
            Book(title: "개미", colorCode: "D9D9F3")
        ])
    }
    
    
    public func create(content: String) -> Bool {
        /*
         do {
         let sql = """
         INSERT INTO book (content)
         VALUES ( ? )
         """
         
         try self.dbManger.fmdb.executeUpdate(sql, values: [content])
         return true
         } catch let error as NSError {
         print("Insert Error : \(error.localizedDescription)")
         return false
         }
         */
        return true
    }
    
    public func update() {}
    
    public func delete() -> Bool {
        
        return true
    }
}
