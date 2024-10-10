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
        public static func from(hex: String, alpha: CGFloat? = 1.0) -> UIColor {
            let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hexString).scanHexInt64(&int)
            let r, g, b: UInt64
            switch hexString.count {
            case 3: // RGB (12-bit)
                (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (r, g, b) = (0, 0, 0) // Default color for invalid hex string
            }

            return UIColor.init(
                red: CGFloat(r) / 255,
                green: CGFloat(g) / 255,
                blue: CGFloat(b) / 255,
                alpha: CGFloat(alpha) / 255
            )
        }
    }
    
    
    static var twl: TWLUIColorClassExStruct.Type {return TWLUIColorClassExStruct.self}
}
