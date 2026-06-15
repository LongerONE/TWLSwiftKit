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
            guard !searchString.isEmpty else { return [] }

            var ranges: [Range<String.Index>] = []
            var searchStart = self.string.startIndex
            
            while searchStart < self.string.endIndex,
                  let foundRange = self.string.range(
                    of: searchString,
                    options: [],
                    range: searchStart..<self.string.endIndex
                  ) {
                ranges.append(foundRange)
                searchStart = foundRange.upperBound
            }
            
            return ranges
        }
        
        
        public func substring(at location: Int, length: Int) -> String? {
            guard location >= 0, length >= 0, location <= self.string.count,
                  length <= self.string.count - location else { return nil }

            let startIndex = self.string.index(self.string.startIndex, offsetBy: location)
            let endIndex = self.string.index(startIndex, offsetBy: length)
            return String(self.string[startIndex..<endIndex])
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
        
        
        public var prettyJSONString: String? {
            guard let data = self.string.data(using: .utf8) else {
                return nil
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
                return String(data: prettyData, encoding: .utf8)
            } catch {
                TWLDPrint("JSON 解析或格式化失败: \(error.localizedDescription)")
                return nil
            }
        }
    }
    

     var twl: TWLStringStruct {
        return TWLStringStruct(self)
    }
}
