//
//  MemoListCell.swift
//
//
//  Created by 박세라 on 5/21/24.
//

import Model
import UIKit

protocol MemoListCellDelegate: AnyObject {
    func memoListCellDeleteTapped(memoID: Memo.ID)
}

class MemoListCell: UICollectionViewCell {
    
    private weak var contentLabel: UILabel!
    private weak var baseView: UIView!

    private var memoID: Memo.ID!
    weak var delegate: MemoListCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray5
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let baseView = UIView()
        baseView.backgroundColor = .systemGray
        self.contentView.addSubview(baseView)
        baseView.leadingToSuperview(offset: 4)
        baseView.trailingToSuperview(offset: 4)
        baseView.topToSuperview(offset: 4)
        baseView.bottomToSuperview(offset: -4)
        self.baseView = baseView
        
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        self.contentView.addSubview(contentLabel)
        contentLabel.leading(to: baseView, offset: 8)
        contentLabel.trailing(to: baseView, offset: 8)
        contentLabel.top(to: baseView, offset: 8)
        contentLabel.bottom(to: baseView, offset: -8)
        self.contentLabel = contentLabel
        
        let deleteButton = UIButton()
        let deleteImage = UIImage(systemName: "x.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        self.contentView.addSubview(deleteButton)
        deleteButton.trailingToSuperview(offset: 16)
        deleteButton.centerYToSuperview()
    }
    
    func configure(with memo: Memo) {
        self.layer.cornerRadius = 4
        self.baseView.layer.cornerRadius = 4
        self.memoID = memo.memoID
        self.contentLabel.text = memo.content
    }
    
    @objc private func deleteTapped() {
        self.delegate?.memoListCellDeleteTapped(memoID: self.memoID)
    }
}
    
