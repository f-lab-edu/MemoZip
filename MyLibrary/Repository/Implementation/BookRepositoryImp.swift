//
//  BookRepositoryImp.swift
//  
//
//  Created by 박세라 on 5/24/24.
//

import Model
import Repository
import RxSwift
import Foundation

public class BookRepositoryImp: BookRepository {
    
    private let dbManger = DBManger()
    
    public init() {}
    
    public func fetch() -> Observable<[Book]> {
        
         var bookList = [Book]()
        
        do {
            let sql = "SELECT * FROM book"
            
            let rs = try self.dbManger.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                let title = rs.string(forColumn: "bookTitle")
                let startDt = rs.string(forColumn: "startDate")
                let endDate = rs.string(forColumn: "endDate")
                let startPage = rs.int(forColumn: "startPage")
                let endPage = rs.int(forColumn: "endPage")
                let colorCode = rs.string(forColumn: "colorCode")
                let isDisplayDday = rs.int(forColumn: "isDisplayDday")
                
                bookList.append(Book(title: title!,
                                     startDt: startDt, endDt: endDate,
                                     startPage: Int(startPage), endPage: Int(endPage),
                                     colorCode: colorCode!,
                                     isDisplayDday: isDisplayDday == 0))
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        print("bookList: \(bookList)")
        return .just(bookList)
        /*
         return .just([
         Book(title: "Clean Code", colorCode: "FFD4A5"),
         Book(title: "개미", colorCode: "D9D9F3")
         ])
         */
    }
    
    
    public func create(book: Book) -> Bool {
        print("create(book:\(book)")
        do {
            let sql = """
         INSERT INTO book (bookTitle, startDate, endDate, startPage, endPage, colorCode, isDisplayDday)
         VALUES (?, ?, ?, ?, ?, ?, ?)
         """
            try self.dbManger.fmdb.executeUpdate(sql, values: [book.title, book.startDt!, book.endDt!, book.startPage ?? 0, book.endPage ?? 0, book.colorCode, book.isDisplayDday ?? true]) 
            // FIXME: 우선은.. date 강제 옵셔널 처리
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }
    
    public func update() {}
    
    public func delete() -> Bool {
        
        return true
    }
}
