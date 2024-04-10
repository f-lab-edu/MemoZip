//
//  HomeViewController+Section.swift
//
//
//  Created by 박세라 on 4/1/24.
//
import RxDataSources
import Foundation

// TODO: Header 추가
struct HomeSection {
    var header: String
    var items: [Item]
    var identity: String
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
        self.identity = UUID().uuidString
    }
}
enum HomeSectionItem {
    case defaultCell(TodoListCellReactor)
    case planCell(PlanListCellReactor)
    case categoryCell([String])
    // ...
}
extension HomeSection: SectionModelType {
   
    typealias Item = HomeSectionItem
    
    init(original: HomeSection, items: [HomeSectionItem]) {
        self = original
        self.items = items
    }
}
