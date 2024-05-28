//
//  BookProgressFormCell.swift
//
//
//  Created by 박세라 on 5/28/24.
//
//  달성율 표기방식 선택 Cell

import UIKit
import TinyConstraints

class BookProgressFormCell: UICollectionViewCell {
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
    
    @objc private func segmentedControlValueChanged() {
        switch pickView.selectedSegmentIndex {
        case 0: // d-day
            print("d-day 선택됨")
        case 1: // 소수점 선택 시 처리할 코드
            print("쪽수로 선택됨")
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        
    }
}
