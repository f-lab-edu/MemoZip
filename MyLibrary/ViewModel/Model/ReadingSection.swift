//
//  ReadingSection.swift
//
//
//  Created by 박세라 on 5/23/24.
//

import RxDataSources
import Foundation


public struct ReadingSection {
    public var header: String
    public var items: [Item]
    public var identity: String
    
    public init(header: String, items: [Item]) {
        self.header = header
        self.items = items
        self.identity = UUID().uuidString
    }
}

public enum ReadingSectionItem {
    case titleCell
    case dateCell
    case pageCell
    case colorCell
    case progressTypeCell
    // ...
}

extension ReadingSection: SectionModelType {
   
    public typealias Item = ReadingSectionItem
    
    public init(original: ReadingSection, items: [ReadingSectionItem]) {
        self = original
        self.items = items
    }
}
