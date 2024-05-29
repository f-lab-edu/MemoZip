//
//  BookColorCell.swift
//
//
//  Created by 박세라 on 5/27/24.
//
// 독서 - 커버 색상 선택 목록 Cell

import UIKit
import ReactorKit
import ViewModel

import TinyConstraints

final class BookColorCell: UICollectionViewListCell, View {
    
    typealias Reactor = BookColorCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    let colorCodes = BookColorType.allCases.map { $0.colorCode }
    var selectedIndexPath: IndexPath? // 선택된 셀의 인덱스를 저장하는 변수
    var delegate: SendDelegate?
    
    // MARK: - view
    let palletView: UICollectionView
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "커버 색상 선택"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.scrollDirection = .horizontal
        self.palletView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        [palletView, titleLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        palletView.height(48)
        palletView.leadingToSuperview()
        palletView.trailingToSuperview()
        palletView.bottomToSuperview()
        
        palletView.dataSource = self
        palletView.delegate = self
        
        palletView.register(ColorChipCell.self)
        
        palletView.showsHorizontalScrollIndicator = false
        
        titleLabel.leadingToSuperview()
        titleLabel.trailingToSuperview()
        titleLabel.topToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: BookColorCellReactor) {
        
    }
}

extension BookColorCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ColorChipCell.self, for: indexPath)
        cell.configure(colorCode: colorCodes[indexPath.item])
        cell.checkView.isHidden = !(indexPath == selectedIndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        delegate?.getValue(type: .colorCell, data: ["colorCd": colorCodes[indexPath.item]])
        collectionView.reloadData()
    }
}
