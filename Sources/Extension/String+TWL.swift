//
//  String+TWL.swift
//  Temby
//
//  Created by 唐万龙 on 2023/6/1.
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
        
        
        func addQuery(key:String, value: String) -> String {
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
    }
    

     var twl: TWLStringStruct {
        return TWLStringStruct(self)
    }
}
