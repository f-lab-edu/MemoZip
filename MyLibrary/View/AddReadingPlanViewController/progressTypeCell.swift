//
//  BookProgressTypeCell.swift
//
//
//  Created by 박세라 on 5/28/24.
//
//  달성율 표기방식 선택 Cell

import UIKit
import TinyConstraints

import Model

class BookProgressTypeCell: UICollectionViewCell {
    // MARK: UI
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "달성률 표기 방식 선택"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    let pickView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "D-day로", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "쪽수로", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0 // 기본 선택 인덱스 설정
        return segmentedControl
    }()
    
    var delegate: SendDelegate?
    
    public override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }
    
    private func setupViews() {
        [titleLabel, pickView].forEach {
            self.contentView.addSubview($0)
        }
        
        titleLabel.leadingToSuperview()
        titleLabel.trailingToSuperview()
        titleLabel.topToSuperview()
        
        pickView.topToBottom(of: titleLabel, offset: 8)
        pickView.leadingToSuperview()
        pickView.trailingToSuperview()
        pickView.bottomToSuperview()
    }
    
    private func setupActions() {
        pickView.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    func configure(with book: Book) {
        pickView.selectedSegmentIndex = book.isDisplayDday ? 0 : 1
    }
    
    @objc private func segmentedControlValueChanged() {
        delegate?.getValue(type: .progressTypeCell, data: ["progressType" : pickView.selectedSegmentIndex])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        
    }
}
