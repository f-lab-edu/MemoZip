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
    public var items: [HomeSectionItem]
}

public enum HomeSectionItem {
    case title(String)
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
