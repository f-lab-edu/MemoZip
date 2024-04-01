//
//  TodoListCell.swift
//
//
//  Created by 박세라 on 4/1/24.
//

import UIKit
import ReactorKit

class TodoListCell: UITableViewCell, View {
    
    typealias Reactor = TodoListCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let completeButton = UIButton()
    
    // ...
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(reactor: TodoListCellReactor) {
        self.titleLabel.text = reactor.currentState.title
        self.detailLabel.text = reactor.currentState.subTitle
        let completeImage = (reactor.currentState.isComplete ?? false) ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        self.completeButton.setImage(completeImage, for: .normal)
    }
}
