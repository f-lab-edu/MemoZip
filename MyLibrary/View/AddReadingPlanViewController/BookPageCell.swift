//
//  BookPageCell.swift
//
//
//  Created by 박세라 on 5/28/24.
//
//  읽은 페이지수 / 전체 페이지 입력 Cell

import UIKit
import TinyConstraints

final class BookPageCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "읽은 페이지"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    let readingView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        return view
    }()
    
    let bookImageView: UIImageView = {
        let imageView = UIImageView()
        let bookImage = UIImage(systemName: "book")
        imageView.image = bookImage?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    let readPageTextLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "읽은 페이지"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return titleLabel
    }()
    
    let pageTextLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "쪽"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return titleLabel
    }()
    
    let pageLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        return titleLabel
    }()
    
     
    var showAlertAction: (() -> ())?
    
    public override func prepareForReuse() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestureRecognizers()
    }
    
    private func setupViews() {
        [titleLabel, readingView, bookImageView, readPageTextLabel, pageTextLabel, pageLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        titleLabel.leadingToSuperview()
        titleLabel.trailingToSuperview()
        titleLabel.topToSuperview(offset: 8)
        
        readingView.leadingToSuperview()
        readingView.trailingToSuperview()
        readingView.bottomToSuperview()
        readingView.height(44)
        
        bookImageView.centerY(to: readingView)
        bookImageView.leftToSuperview(offset: 8)
        
        readPageTextLabel.centerY(to: readingView)
        readPageTextLabel.leftToSuperview(offset: 36)
        
        pageTextLabel.centerY(to: readingView)
        pageTextLabel.trailingToSuperview(offset: 16)
        
        pageLabel.centerY(to: readingView)
        pageLabel.trailing(to: pageTextLabel, offset: -20)
    
    }
    
    private func setupGestureRecognizers() {
        let readingViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(readingViewTapped))
        readingView.addGestureRecognizer(readingViewTapGesture)
    }
    
    @objc private func readingViewTapped() {
        showAlertAction?()
    }
    
    func updatePage(startPage: Int, endPage: Int) {
        self.pageLabel.text = "\(startPage) / \(endPage)"
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        
    }
}
