//
//  UIColor+TWL.swift
//  Temby
//
//  Created by 唐万龙 on 2023/6/7.
//

import UIKit


public extension UIColor {
    convenience init(twlhex: String, alpha: CGFloat = 1.0) {
        let hexString = twlhex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexString).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Default color for invalid hex string
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    // MARK: TWLUIViewClassExStruct
    struct TWLUIColorClassExStruct {
        public static func from(hex: String, alpha: CGFloat = 1.0) -> UIColor {
            return UIColor(twlhex: hex, alpha: alpha)
        }
    }
    
    
    static var twl: TWLUIColorClassExStruct.Type {return TWLUIColorClassExStruct.self}
}
