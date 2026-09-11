//
//  Array+Ex.swift
//

import Foundation

public extension Array {
    struct TWLArrayStruct {
        private let array: [Any]
        
        init(_ array: [Any]) {
            self.array = array
        }
        
        public var jsonString: String? {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonString
            } catch {
                TWLDPrint("❌ 数组转 JSON String 失败: \(error.localizedDescription)")
                return nil
            }
        }
        
        
        public var prettyJsonString: String? {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonString
            } catch {
                TWLDPrint("❌ 数组转 JSON String 失败: \(error.localizedDescription)")
                return nil
            }
        }

        @available(*, deprecated, renamed: "jsonString")
        public var JSONString: String? { jsonString }

        @available(*, deprecated, renamed: "prettyJsonString")
        public var prettyJSONString: String? { prettyJsonString }
    }
    
    
    var twl: TWLArrayStruct {
        TWLArrayStruct(map { $0 as Any })
    }
}
