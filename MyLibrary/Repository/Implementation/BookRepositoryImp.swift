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
                let bookId = rs.int(forColumn: "bookId")
                let title = rs.string(forColumn: "bookTitle")
                let startAt = rs.string(forColumn: "startDate")
                let endDate = rs.string(forColumn: "endDate")
                let startPage = rs.int(forColumn: "startPage")
                let endPage = rs.int(forColumn: "endPage")
                let colorCode = rs.string(forColumn: "colorCode")
                let isDisplayDday = rs.int(forColumn: "isDisplayDday")
                
                bookList.append(Book(bookId: bookId,
                                     title: title!,
                                     startAt: startAt, endAt: endDate,
                                     startPage: Int(startPage), endPage: Int(endPage),
                                     colorCode: colorCode!,
                                     isDisplayDday: isDisplayDday == 0))
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return .just(bookList)
    }
    
    
    public func create(book: Book) -> Bool {
        
        do {
            let sql = """
         INSERT INTO book (bookTitle, startDate, endDate, startPage, endPage, colorCode, isDisplayDday)
         VALUES (?, ?, ?, ?, ?, ?, ?)
         """
            try self.dbManger.fmdb.executeUpdate(sql, values: [book.title, book.startAt!, book.endAt!, book.startPage ?? 0, book.endPage ?? 0, book.colorCode, book.isDisplayDday ?? true]) 
            // FIXME: 우선은.. date 강제 옵셔널 처리
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }
    
    public func update(book: Book) -> Bool {
        do {
            let sql = """
                UPDATE book
                SET bookTitle = ?, startDate = ?, endDate = ?, startPage = ?, endPage = ?, colorCode = ?, isDisplayDday = ?
                WHERE bookId = ?
                """
            try self.dbManger.fmdb.executeUpdate(sql, values: [
                book.title,
                book.startAt ?? "",
                book.endAt ?? "",
                book.startPage ?? 0,
                book.endPage ?? 0,
                book.colorCode,
                book.isDisplayDday ?? true ? 1 : 0,
                book.bookId
            ])
            return true
        } catch let error as NSError {
            print("Update Error: \(error.localizedDescription)")
            return false
        }
    }
    
    public func delete(bookId: Int32) -> Bool {
        do {
            let sql = "DELETE FROM book WHERE bookId = ?"
            try self.dbManger.fmdb.executeUpdate(sql, values: [bookId])
            return true
        } catch let error as NSError {
            print("Delete Error: \(error.localizedDescription)")
            return false
        }
    }
}
