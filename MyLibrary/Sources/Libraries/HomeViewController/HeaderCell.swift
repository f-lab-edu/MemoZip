//
//  HeaderCell.swift
//
//
//  Created by 박세라 on 4/2/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import ViewModel
import ViewModelImp

class HeaderCell: UICollectionReusableView, View {
    
    typealias Reactor = HeaderCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    
    var addButton = UIButton()
    // ...
    
    var voidHandler: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(addButton)
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.left(to: self, offset: 8)
        titleLabel.centerYToSuperview()
        
        addButton.setImage(UIImage(systemName: "plus.app"), for: .normal)
        addButton.height(20)
        addButton.width(20)
        addButton.centerYToSuperview()
        addButton.right(to: self, offset: -8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: HeaderCellReactor) {
        
        titleLabel.text = reactor.initialState.headerTitle
        
        addButton.rx.tap
            .map{ _ in Reactor.Action.buttonTapped}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isButtonTapped }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isTapped in
                // 버튼의 상태에 따라 UI 업데이트 로직 수행
                //HomeViewReactor.Action.addItem()
                self?.voidHandler?()
            })
            .disposed(by: disposeBag)
        
        
    }
}
