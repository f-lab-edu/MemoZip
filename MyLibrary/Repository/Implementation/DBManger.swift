//
//  DBManger.swift
//
//
//  Created by 박세라 on 5/17/24.
//

import Foundation
import FMDB

public class DBManger {
    
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
}
