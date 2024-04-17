//
//  UIColor+TWL.swift
//  Temby
//
//  Created by 唐万龙 on 2023/6/7.
//

import UIKit


public extension UIColor {
    
    // MARK: TWLUIViewClassExStruct
    struct TWLUIColorClassExStruct {
        @available(iOS 13.0, *)
        static func from(hex: String, alpha: CGFloat = 1.0) -> UIColor {
            let scanner = Scanner(string: hex)
              scanner.currentIndex = hex.hasPrefix("#") ? hex.index(after: hex.startIndex) : hex.startIndex
              var rgbValue: UInt64 = 0
              scanner.scanHexInt64(&rgbValue)

              let r = (rgbValue & 0xFF0000) >> 16
              let g = (rgbValue & 0x00FF00) >> 8
              let b = rgbValue & 0x0000FF
            
             return UIColor.init(
                  red: CGFloat(r) / 0xFF,
                  green: CGFloat(g) / 0xFF,
                  blue: CGFloat(b) / 0xFF,
                  alpha: alpha
              )
        }
    }
    
    
    static var twl: TWLUIColorClassExStruct.Type {return TWLUIColorClassExStruct.self}
}
