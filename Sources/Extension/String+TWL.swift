//
//  String+TWL.swift
//

import Foundation
import UIKit

public extension String {
        
    struct TWLStringStruct {
        private let string: String
        
        init(_ string: String) {
            self.string = string
        }
        
        // 移除前面空格
        public var trimmedLeadingWhitespace: String {
            if let range = self.string.rangeOfCharacter(from: .whitespacesAndNewlines.inverted) {
                return String(self.string[range.lowerBound...])
            }
            return self.string
        }
        
        public var localized: String {
            return NSLocalizedString(self.string, comment: "")
        }
        
        public var addPercent: String {
            return self.string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self.string
        }

        public var addPercentAllowLetters: String {
            return self.string.addingPercentEncoding(withAllowedCharacters: .letters) ?? self.string
        }
        
        public var array: Array<Any>? {
            if let jsonData = self.string.data(using: .utf8) {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Array<Any>
                    return jsonArray
                } catch let error {
                    TWLDPrint("❌ JSON String 转数组失败: \(error.localizedDescription)")
                    return nil
                }
            } else {
                return nil
            }
        }
        
        public var dict: [String: Any]? {
            if let jsonData = self.string.data(using: .utf8) {
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                    return jsonDictionary
                } catch {
                    TWLDPrint("❌ JSON String 转字典失败: \(error.localizedDescription)")
                    return nil
                }
            } else {
                return nil
            }
        }
        
        public func addQuery(key:String, value: String) -> String {
            if self.string.contains("?") {
                return "\(self.string)&\(key)=\(value)"
            } else {
                return "\(self.string)?\(key)=\(value)"
            }
        }
        
        public var color: UIColor? {
            get {
                return UIColor.twl.from(hex: self.string)
            }
        }
        
        /// 返回指定字符串中所有目标子字符串的 Range
        /// - Parameters:
        ///   - searchString: 搜索字符串
        /// - Returns: Range数组
        public func ranges(of searchString: String) -> [Range<String.Index>] {
            var ranges: [Range<String.Index>] = []
            var searchRange: Range<String.Index>?
            
            while let foundRange = self.string.range(of: searchString, options: [], range: searchRange) {
                ranges.append(foundRange)
                // 更新搜索范围，避免重复找到相同的字符串
                searchRange = Range(uncheckedBounds: (foundRange.upperBound, self.string.endIndex))
            }
            
            return ranges
        }
        
        
        public func substring(at location: Int, length: Int) -> String? {
            if location > self.string.count || (location+length > self.string.count) {
                return nil
            }
            var subStr: String = ""
            for idx in location..<(location+length) {
                subStr += self.string[self.string.index(self.string.startIndex, offsetBy: idx)].description
            }
            return subStr
        }
        
        /// 从开头到指定位置（不含该位置）的子串
        public func substring(to location: Int) -> String? {
            guard location >= 0, location <= self.string.count else {
                return nil
            }
            let endIndex = self.string.index(self.string.startIndex, offsetBy: location)
            return String(self.string[self.string.startIndex..<endIndex])
        }

        /// 从指定位置到结尾的子串
        public func substring(from location: Int) -> String? {
            guard location >= 0, location <= self.string.count else {
                return nil
            }
            let startIndex = self.string.index(self.string.startIndex, offsetBy: location)
            return String(self.string[startIndex..<self.string.endIndex])
        }
        
    }
    

     var twl: TWLStringStruct {
        return TWLStringStruct(self)
    }
}
