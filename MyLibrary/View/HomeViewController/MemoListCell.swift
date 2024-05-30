//
//  MemoListCell.swift
//
//
//  Created by 박세라 on 5/21/24.
//

import UIKit
import ReactorKit
import ViewModel

class MemoListCell: UICollectionViewCell, View {

    typealias Reactor = MemoListCellReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI
    let contentLabel = UILabel()
    let baseView = UIView()
    let deleteButton: UIButton = {
        let button = UIButton()
        let deleteImage = UIImage(systemName: "x.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(deleteImage, for: .normal)
        //button.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
        return button
    }()
    
    override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [baseView, contentLabel, deleteButton].forEach {
            self.contentView.addSubview($0)
        }
        
        self.backgroundColor = .systemGray5
    
        baseView.leadingToSuperview(offset: 4)
        baseView.trailingToSuperview(offset: 4)
        baseView.topToSuperview(offset: 4)
        baseView.bottomToSuperview(offset: -4)
        
        baseView.backgroundColor = .systemGray
        
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        
        contentLabel.leading(to: baseView, offset: 8)
        contentLabel.trailing(to: baseView, offset: 8)
        contentLabel.top(to: baseView, offset: 8)
        contentLabel.bottom(to: baseView, offset: -8)
        
        deleteButton.trailingToSuperview(offset: 16)
        deleteButton.centerYToSuperview()
        
        bringSubviewToFront(contentLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: MemoListCellReactor) {
        // 부분 cornerRadius 적용
        self.layer.cornerRadius = 4
        self.baseView.layer.cornerRadius = 4
        self.contentLabel.text = reactor.currentState.content
    }
}
    
