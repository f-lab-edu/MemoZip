//
//  ReminderViewController+Section.swift
//  
//
//  Created by 박세라 on 3/27/24.
//

import Foundation

@available(iOS 15.0, *)
extension ReminderViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes

        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .date:
                return NSLocalizedString("Date", comment: "Date section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Notes section name")
            }
        }
    }
}
