//
//  Section.swift
//
//
//  Created by 박세라 on 4/1/24.
//
import RxDataSources

enum HomeSection {
    case first([TableViewCellSectionItem])
    // ...
}
enum TableViewCellSectionItem {
    case defaultCell(TodoListCellReactor)
    // ...
}
extension HomeSection: SectionModelType {
    
    typealias Item = TableViewCellSectionItem
    
    var items: [Item] {
        switch self {
        case .first(let items):
            return items
        // ...
        }
    }
    
    init(original: HomeSection, items: [TableViewCellSectionItem]) {
        switch original {
        case .first:
            self = .first(items)
        // ...
        }
    }
    
}
