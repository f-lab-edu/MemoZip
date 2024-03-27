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
        UIColor(named: "TodayDetailCellTint") ?? .tintColor
    }

    static var todayListCellBackground: UIColor {
        UIColor(named: "TodayListCellBackground") ?? .secondarySystemBackground
    }

    static var todayListCellDoneButtonTint: UIColor {
        UIColor(named: "TodayListCellDoneButtonTint") ?? .tintColor
    }

    static var todayGradientAllBegin: UIColor {
        UIColor(named: "TodayGradientAllBegin") ?? .systemFill
    }

    static var todayGradientAllEnd: UIColor {
        UIColor(named: "TodayGradientAllEnd") ?? .quaternarySystemFill
    }

    static var todayGradientFutureBegin: UIColor {
        UIColor(named: "TodayGradientFutureBegin") ?? .systemFill
    }

    static var todayGradientFutureEnd: UIColor {
        UIColor(named: "TodayGradientFutureEnd") ?? .quaternarySystemFill
    }

    static var todayGradientTodayBegin: UIColor {
        UIColor(named: "TodayGradientTodayBegin") ?? .systemFill
    }

    static var todayGradientTodayEnd: UIColor {
        UIColor(named: "TodayGradientTodayEnd") ?? .quaternarySystemFill
    }

    static var todayNavigationBackground: UIColor {
        UIColor(named: "TodayNavigationBackground") ?? .secondarySystemBackground
    }

    static var todayPrimaryTint: UIColor {
        UIColor(named: "TodayPrimaryTint") ?? .tintColor
    }

    static var todayProgressLowerBackground: UIColor {
        UIColor(named: "TodayProgressLowerBackground") ?? .systemGray
    }

    static var todayProgressUpperBackground: UIColor {
        UIColor(named: "TodayProgressUpperBackground") ?? .systemGray6
    }
}
