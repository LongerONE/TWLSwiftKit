//
//  String+TWL.swift
//  Temby
//
//  Created by 唐万龙 on 2023/6/1.
//

import Foundation


public extension String {
    
    var trimmedLeadingWhitespace: String {
        if let range = self.rangeOfCharacter(from: .whitespacesAndNewlines.inverted) {
            return String(self[range.lowerBound...])
        }
        return self
    }
    
    public struct TWLStringStruct {
        private let string: String
        
        init(_ string: String) {
            self.string = string
        }
        
        var localized: String {
            return NSLocalizedString(self.string, comment: "")
        }
        
        var addPercent: String {
            return self.string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self.string
        }

        var addPercentAllowLetters: String {
            return self.string.addingPercentEncoding(withAllowedCharacters: .letters) ?? self.string
        }
        
        
        var array:Array<Any>? {
            if let jsonData = self.string.data(using: .utf8) {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
                    return jsonArray
                } catch let error {
                    TWLDPrint("Error converting JSON to array: \(error.localizedDescription)")
                    return nil
                }
            } else {
                return nil
            }
        }
        
        var dict: [String: Any]? {
            if let jsonData = self.string.data(using: .utf8) {
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                    return jsonDictionary
                } catch {
                    TWLDPrint("Error converting JSON to dictionary: \(error.localizedDescription)")
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
    }
    

    public var twl: TWLStringStruct {
        return TWLStringStruct(self)
    }
}
