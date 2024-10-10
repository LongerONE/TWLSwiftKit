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
        public static func from(hex: String, alpha: CGFloat? = 1.0) -> UIColor? {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            let length = hexSanitized.count
            
            guard length == 6 || length == 8 else {
                return nil
            }
            
            var rgb: UInt64 = 0
            
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let red, green, blue, a: CGFloat
            if length == 6 {
                red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(rgb & 0x0000FF) / 255.0
                a = alpha ?? 1.0
            } else if length == 8 {
                red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgb & 0x000000FF) / 255.0
            } else {
                return nil
            }
            
            

            return UIColor.init(red: red, green: green, blue: blue, alpha: a)
        }
    }
    
    
    static var twl: TWLUIColorClassExStruct.Type {return TWLUIColorClassExStruct.self}
}
