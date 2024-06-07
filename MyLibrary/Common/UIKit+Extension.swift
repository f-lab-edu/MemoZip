//
//  UIColor+Extension.swift
//
//
//  Created by 박세라 on 4/2/24.
//
import UIKit

protocol HasTypeName {
  
}

extension HasTypeName {
    public static var typeName: String { String(describing: self) }
}

extension UIView: HasTypeName {
  
}
// MARK: UICollectionView
extension UICollectionView {
    package func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: T.typeName)
    }
    
    package func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.typeName, for: indexPath) as! T
    }
    
    package func registerHeader<T: UICollectionReusableView>(_ viewClass: T.Type) {
        self.register(viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.typeName)
    }
    
    package func dequeueReusableView<T: UICollectionReusableView>(_ cellClass: T.Type, kind: String, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.typeName, for: indexPath) as! T
    }
}

// MARK: UIView
extension UIView {
    package func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
