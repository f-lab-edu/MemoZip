//
//  HeaderCell.swift
//
//
//  Created by 박세라 on 4/2/24.
//

import UIKit

class HeaderCell: UICollectionReusableView {
    
    private weak var titleLabel: UILabel!
    private weak var addButton: UIButton!
    private var addTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        self.addSubview(titleLabel)
        titleLabel.leadingToSuperview(offset: 16)
        titleLabel.centerYToSuperview()
        self.titleLabel = titleLabel
        
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.app"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        self.addSubview(addButton)
        addButton.width(20)
        addButton.height(20)
        addButton.trailingToSuperview(offset: 16)
        addButton.centerYToSuperview()
        self.addButton = addButton
    }
    
    func configure(with title: String, addTapped: (() -> Void)?) {
        self.titleLabel.text = title
        self.addTapped = addTapped
        self.addButton.isHidden = addTapped == nil
    }
    
    @objc private func addButtonTapped() {
        self.addTapped?()
    }
}
