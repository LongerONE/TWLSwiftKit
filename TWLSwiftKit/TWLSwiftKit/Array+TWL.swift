//
//  Array+Ex.swift
//  Temby
//
//  Created by 唐万龙 on 2023/5/29.
//

import Foundation

extension Array  {
    struct TWLArrayStruct {
        private var arrry: Array
        
        init(_ arrry: Array) {
            self.arrry = arrry
        }
        
        var JSONString: String? {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.arrry, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonString
            } catch {
                TWLDPrint("Error converting array to JSON: \(error.localizedDescription)")
                return nil
            }
        }
        
    }
    
    
    var twl: TWLArrayStruct {
        return TWLArrayStruct(self)
    }
}

