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
            if let range = string.rangeOfCharacter(from: .whitespacesAndNewlines.inverted) {
                return String(string[range.lowerBound...])
            }
            return string
        }
        
        public var localized: String {
            NSLocalizedString(string, comment: "")
        }
        
        public var addPercent: String {
            string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
        }

        public var addPercentAllowLetters: String {
            string.addingPercentEncoding(withAllowedCharacters: .letters) ?? string
        }
        
        public var array: Array<Any>? {
            if let jsonData = string.data(using: .utf8) {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Array<Any>
                    return jsonArray
                } catch {
                    TWLDPrint("❌ JSON String 转数组失败: \(error.localizedDescription)")
                    return nil
                }
            } else {
                return nil
            }
        }
        
        public var dict: [String: Any]? {
            if let jsonData = string.data(using: .utf8) {
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
        
        public func addQuery(key: String, value: String) -> String {
            if string.contains("?") {
                return "\(string)&\(key)=\(value)"
            } else {
                return "\(string)?\(key)=\(value)"
            }
        }
        
        @MainActor
        public var color: UIColor? { UIColor.twl.from(hex: string) }
        
        /// 返回指定字符串中所有目标子字符串的 Range
        /// - Parameters:
        ///   - searchString: 搜索字符串
        /// - Returns: Range数组
        public func ranges(of searchString: String) -> [Range<String.Index>] {
            guard !searchString.isEmpty else { return [] }

            var ranges: [Range<String.Index>] = []
            var searchStart = string.startIndex

            while searchStart < string.endIndex,
                  let foundRange = string.range(
                    of: searchString,
                    options: [],
                    range: searchStart..<string.endIndex
                  ) {
                ranges.append(foundRange)
                searchStart = foundRange.upperBound
            }
            
            return ranges
        }
        
        
        public func substring(at location: Int, length: Int) -> String? {
            guard location >= 0, length >= 0, location <= string.count,
                  length <= string.count - location else { return nil }

            let startIndex = string.index(string.startIndex, offsetBy: location)
            let endIndex = string.index(startIndex, offsetBy: length)
            return String(string[startIndex..<endIndex])
        }
        
        /// 从开头到指定位置（不含该位置）的子串
        public func substring(to location: Int) -> String? {
            guard location >= 0, location <= string.count else {
                return nil
            }
            let endIndex = string.index(string.startIndex, offsetBy: location)
            return String(string[string.startIndex..<endIndex])
        }

        /// 从指定位置到结尾的子串
        public func substring(from location: Int) -> String? {
            guard location >= 0, location <= string.count else {
                return nil
            }
            let startIndex = string.index(string.startIndex, offsetBy: location)
            return String(string[startIndex..<string.endIndex])
        }
        
        
        public var prettyJsonString: String? {
            guard let data = string.data(using: .utf8) else {
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

        @available(*, deprecated, renamed: "prettyJsonString")
        public var prettyJSONString: String? { prettyJsonString }
    }
    

    var twl: TWLStringStruct {
        TWLStringStruct(self)
    }
}
