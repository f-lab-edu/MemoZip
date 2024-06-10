//
//  HomeViewController+Section.swift
//
//
//  Created by 박세라 on 4/1/24.
//
import Model
import Foundation
import RxDataSources

public struct HomeSection {
    public enum ID: Int {
        case todo
        case plan
    }
    public var id: ID
    public var header: String
    public var items: [HomeSectionItem]
}

public enum HomeSectionItem {
    case todo(TodoListCellReactor)
    case planType(PlanType)
    case memo(Memo)
    case book(BookListCellReactor)
}

extension HomeSection: SectionModelType {
   
    public typealias Item = HomeSectionItem
    
    public init(original: HomeSection, items: [HomeSectionItem]) {
        self = original
        self.items = items
    }
}
