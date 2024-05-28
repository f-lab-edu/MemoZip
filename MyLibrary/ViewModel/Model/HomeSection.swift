//
//  HomeViewController+Section.swift
//
//
//  Created by 박세라 on 4/1/24.
//
import Model
import Foundation
import RxDataSources

// TODO: Header 추가
public struct HomeSection {
    public var header: String
    public var items: [HomeSectionItem]
    public var identity: String
    
    public init(header: String, items: [HomeSectionItem]) {
        self.header = header
        self.items = items
        self.identity = UUID().uuidString
    }
}
public enum HomeSectionItem {
    case defaultCell(TodoListCellReactor)
    case categoryCell([String])
    case planTypesCell(PlanType)
    case bookCell(BookListCellReactor)
    case memoCell(MemoListCellReactor)
    // ...
}

extension HomeSection: SectionModelType {
   
    public typealias Item = HomeSectionItem
    
    public init(original: HomeSection, items: [HomeSectionItem]) {
        self = original
        self.items = items
    }
}
