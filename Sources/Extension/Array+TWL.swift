//
//  Array+Ex.swift
//  Temby
//
//  Created by 唐万龙 on 2023/5/29.
//

import Foundation

public extension Array  {
    struct TWLArrayStruct {
        private var arrry: Array
        
        init(_ arrry: Array) {
            self.arrry = arrry
        }
        
        public var JSONString: String? {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.arrry, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonString
            } catch {
                TWLDPrint("❌ 数组转 JSON String 失败: \(error.localizedDescription)")
                return nil
            }
        }
        
    }
    
    
    var twl: TWLArrayStruct {
        return TWLArrayStruct(self)
    }
}

