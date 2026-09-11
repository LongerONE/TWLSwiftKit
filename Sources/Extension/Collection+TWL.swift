//
//  Collection+TWL.swift
//  TWLSwiftKit
//
//
import Foundation

public extension Collection {
    subscript(twl index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    var twl: TWLCollectionStruct {
        TWLCollectionStruct(self)
    }
}



public struct TWLCollectionStruct {
    private let collection: any Collection
    
    init(_ collection: any Collection) {
        self.collection = collection
    }
    
    public var jsonString: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: collection, options: .fragmentsAllowed)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            TWLDPrint("Error converting collection to JSON: \(error)")
        }

        return nil
    }
    
    public var prettyJsonString: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: collection, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            TWLDPrint("Error converting collection to JSON: \(error)")
        }

        return nil
    }

    @available(*, deprecated, renamed: "prettyJsonString")
    public var prettyJSONString: String? {
        prettyJsonString
    }
}
