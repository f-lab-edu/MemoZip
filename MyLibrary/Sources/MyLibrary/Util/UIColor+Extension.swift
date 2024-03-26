//
//  UIColor+Extenstion.swift
//  MemoZip
//
//  Created by 박세라 on 3/26/24.
//

import Foundation

import UIKit

@available(iOS 15.0, *)
extension UIColor {
    static var todayDetailCellTint: UIColor {
        UIColor(named: "todayDetailCellTint") ?? .tintColor
    }
    
    static var todayListCellBackground: UIColor {
        UIColor(named: "todayListCellBackground") ?? .secondarySystemBackground
    }
    
    static var todayListCellConeButtonTint: UIColor {
        UIColor(named: "todayListCellConeButtonTint") ?? .tintColor
    }
    
    static var todayGradientAllBegin: UIColor {
        UIColor(named: "todayGradientAllBegin") ?? .systemFill
    }
    
    static var todayGradientAllEnd: UIColor {
        UIColor(named: "todayGradientAllEnd") ?? .quaternarySystemFill
    }
    
    static var todayGradientFutureBegin: UIColor {
        UIColor(named: "todayGradientFutureBegin") ?? .systemFill
    }
    
    static var todayGradientFutureEnd: UIColor {
        UIColor(named: "todayGradientFutureEnd") ?? .quaternarySystemFill
    }
    
    static var todayGradientTodayBegin: UIColor {
        UIColor(named: "todayGradientTodayBegin") ?? .systemFill
    }
    
    static var todayGradientTodayEnd: UIColor {
        UIColor(named: "todayGradientTodayEnd") ?? .quaternarySystemFill
    }
    
    static var todayNavigationBackground: UIColor {
        UIColor(named: "todayNavigationBackground") ?? .secondarySystemGroupedBackground
    }
    
    static var todayPrimaryTint: UIColor {
        UIColor(named: "todayPrimaryTint") ?? .tintColor
    }
    
    static var todayProgressLowerBackground: UIColor {
        UIColor(named: "todayProgressLowerBackground") ?? .systemGray
    }
    
    static var todayProgressUpperBackground: UIColor {
        UIColor(named: "todayProgressUpperBackground") ?? .systemGray6
    }
}
