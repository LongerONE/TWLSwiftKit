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
    
    
}
