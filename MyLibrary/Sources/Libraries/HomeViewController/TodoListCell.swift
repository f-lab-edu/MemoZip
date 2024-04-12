//
//  TodoListCell.swift
//
//
//  Created by 박세라 on 4/1/24.
//

import UIKit
import ReactorKit
import ViewModelImp

class TodoListCell: UICollectionViewListCell, View {
    
    typealias Reactor = TodoListCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let completeButton = UIButton()
    
    // ...
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, detailLabel, completeButton].forEach {
            self.addSubview($0)
        }
        
        completeButton.height(24)
        completeButton.width(24)
        completeButton.centerYToSuperview()
        completeButton.left(to: self.contentView, offset: 8)
        
        titleLabel.numberOfLines = 0
        titleLabel.top(to: self.contentView, offset: 8)
        titleLabel.left(to: self.completeButton, offset: 32)
        titleLabel.centerYToSuperview()
        
        detailLabel.right(to: self.contentView, offset: -8)
        detailLabel.centerYToSuperview()
        
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = .systemGray
        
        self.contentView.backgroundColor = .systemGray5
        self.contentView.layer.cornerRadius = 4
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(reactor: TodoListCellReactor) {
        self.titleLabel.text = reactor.currentState.title
        self.detailLabel.text = reactor.currentState.subTitle
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let completeImage = (reactor.currentState.isComplete ?? false) ? UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig) : UIImage(systemName: "circle", withConfiguration: imageConfig)
        self.completeButton.setImage(completeImage, for: .normal)
    }
}
