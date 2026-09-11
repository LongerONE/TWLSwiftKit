//
//  UIColor+TWL.swift
//

import UIKit


@MainActor
public extension UIColor {

    // MARK: TWLUIViewClassExStruct
    @MainActor
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

            let hexCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
            guard hexSanitized.unicodeScalars.allSatisfy(hexCharacters.contains) else {
                return nil
            }
            
            var rgb: UInt64 = 0
            let scanner = Scanner(string: hexSanitized)
            guard scanner.scanHexInt64(&rgb), scanner.isAtEnd else {
                return nil
            }
            
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
            
            

            return UIColor(red: red, green: green, blue: blue, alpha: a)
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
            
            if !color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                guard color.getWhite(&red, alpha: &alpha) else {
                    return includeAlpha ? "\(prefix)00000000" : "\(prefix)000000"
                }

                green = red
                blue = red
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
    
    
    static var twl: TWLUIColorClassExStruct.Type { TWLUIColorClassExStruct.self }
    
    var twl: TWLUIColorClassExStruct {
        TWLUIColorClassExStruct(self)
    }
}
