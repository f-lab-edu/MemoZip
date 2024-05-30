//
//  MemoListCell.swift
//
//
//  Created by 박세라 on 5/21/24.
//

import UIKit
import ReactorKit
import ViewModel

protocol MemoListCellDelegate: AnyObject {
    func memoListDeleteTapped(of: UICollectionViewCell)
}

class MemoListCell: UICollectionViewCell {
    
    // MARK: - UI
    let contentLabel = UILabel()
    let baseView = UIView()
    let deleteButton: UIButton = UIButton()
    
    weak var delegate: MemoListCellDelegate?
    
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
        
        let deleteImage = UIImage(systemName: "x.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.trailingToSuperview(offset: 16)
        deleteButton.centerYToSuperview()
        
        bringSubviewToFront(contentLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with content: String) {
        self.layer.cornerRadius = 4
        self.baseView.layer.cornerRadius = 4
        self.contentLabel.text = content
    }
    
    @objc private func deleteTapped() {
        self.delegate?.memoListDeleteTapped(of: self)
    }
}
    
