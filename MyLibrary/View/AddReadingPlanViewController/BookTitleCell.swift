//
//  BookTitleCell.swift
//
//
//  Created by 박세라 on 5/23/24.
//
// 독서 - 책 제목 입력 Cell

import UIKit
import ReactorKit
import ViewModel

import TinyConstraints


final class BookTitleCell: UICollectionViewCell, View {
    
    typealias Reactor = BookTitleCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    let bookTextField: UITextField = {
        let paddedTextField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        return paddedTextField
    }()
    
    override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        [titleLabel, bookTextField].forEach {
            self.contentView.addSubview($0)
        }
        
        titleLabel.text = "책 이름"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.leadingToSuperview()
        titleLabel.topToSuperview(offset: 8)
        titleLabel.trailingToSuperview()
    
        bookTextField.backgroundColor = .systemGray4
        
        bookTextField.leadingToSuperview(offset: 8)
        bookTextField.trailingToSuperview(offset: 8)
        bookTextField.bottomToSuperview(offset: -8)
        
        bookTextField.layer.cornerRadius = 8
        
        bookTextField.height(44.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: BookTitleCellReactor) {
        
    }
}
