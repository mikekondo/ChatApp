//
//  UIColor-Extension.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
