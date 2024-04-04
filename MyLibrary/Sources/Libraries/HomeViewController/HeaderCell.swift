//
//  HeaderCell.swift
//
//
//  Created by 박세라 on 4/2/24.
//

import UIKit
import ReactorKit

class HeaderCell: UICollectionReusableView, View {
    
    typealias Reactor = HeaderCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    
    // ...
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.left(to: self, offset: 8)
        titleLabel.centerYToSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(reactor: HeaderCellReactor) {
        self.titleLabel.text = reactor.currentState.title
    }
}
