//
//  ColorChipCell.swift
//
//
//  Created by 박세라 on 5/27/24.
//
//  독서 - 커버 컬러칩 Cell

import Foundation
import UIKit
import TinyConstraints

public class ColorChipCell: UICollectionViewCell {
    let colorView = UIView()
    let checkView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        return view
    }()
    lazy var checkImage: UIImageView = {
        let imageView = UIImageView()
        let checkImage = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.image = checkImage
        return imageView
    }()
    
    public override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        [colorView, checkView].forEach {
            self.addSubview($0)
        }
        
        colorView.edgesToSuperview()
        colorView.layer.cornerRadius = 24
        
        checkView.edgesToSuperview()
        checkView.layer.cornerRadius = 24
        
        checkView.isHidden = true
        
        checkView.addSubview(checkImage)
        checkImage.size(CGSize(width: 24, height: 24))
        checkImage.centerInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(colorCode: String) {
        colorView.backgroundColor = UIColor(hex: colorCode, alpha: 1.0)
    }
}
