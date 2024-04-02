//
//  HomeViewController+Section.swift
//
//
//  Created by 박세라 on 4/1/24.
//
import RxDataSources

// TODO: Header 추가
enum HomeSection {
    case first([HomeSectionItem])
    // ...
}
enum HomeSectionItem {
    case defaultCell(TodoListCellReactor)
    // ...
}
extension HomeSection: SectionModelType {
    
    typealias Item = HomeSectionItem
    
    var items: [Item] {
        switch self {
        case .first(let items):
            return items
        // ...
        }
    }
    
    init(original: HomeSection, items: [HomeSectionItem]) {
        switch original {
        case .first:
            self = .first(items)
        // ...
        }
    }
    
}
