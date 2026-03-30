//
//  UIColor+TWL.swift
//

import UIKit


public extension UIColor {

    // MARK: TWLUIViewClassExStruct
    struct TWLUIColorClassExStruct {
        private let color: UIColor
        
        init(_ color: UIColor) {
            self.color = color
        }
        
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
        
        /// 将 UIColor 转换为十六进制字符串
        /// - Parameters:
        ///   - includeAlpha: 是否包含 Alpha 通道，默认 false
        ///   - prefix: 前缀，默认 "#"
        /// - Returns: 例如 "#RRGGBB" 或 "#RRGGBBAA"
        public func hexString(includeAlpha: Bool = false, prefix: String = "") -> String {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            // 兼容非 RGB 色彩空间（如灰度）
            guard self.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                // 转换失败时返回透明黑，避免崩溃
                return includeAlpha ? "\(prefix)00000000" : "\(prefix)000000"
            }
            
            let r = Int(round(red * 255))
            let g = Int(round(green * 255))
            let b = Int(round(blue * 255))
            let a = Int(round(alpha * 255))
            
            if includeAlpha {
                return String(format: "%@%02X%02X%02X%02X", prefix, r, g, b, a)
            } else {
                return String(format: "%@%02X%02X%02X", prefix, r, g, b)
            }
        }
    }
    
    
    static var twl: TWLUIColorClassExStruct.Type {return TWLUIColorClassExStruct.self}
    
    var twl: TWLUIColorClassExStruct {
        get {
            weak var weakSelf = self
            return TWLUIColorClassExStruct(weakSelf!)
        }
        set {
            
        }
    }
}
