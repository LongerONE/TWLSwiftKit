//
//  Collection+TWL.swift
//  TWLSwiftKit
//
//
import Foundation

public extension Collection {
    subscript(twl index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
     var twl: TWLCollectionStruct {
        return TWLCollectionStruct(self)
    }
    
}



public struct TWLCollectionStruct {
    private let collection: Collection
    
    init(_ collection: Collection) {
        self.collection = collection
    }
    
    public var jsonString: String? {
        get {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.collection, options: .fragmentsAllowed)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            } catch {
                TWLDPrint("Error converting collection to JSON: \(error)")
            }
            
            return nil
        }
        
        set {}
    }
    
    public var prettyJsonString: String? {
        get {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.collection, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            } catch {
                TWLDPrint("Error converting collection to JSON: \(error)")
            }
            
            return nil
        }
        
        set {}
    }
}
