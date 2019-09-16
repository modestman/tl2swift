//
//  File.swift
//  
//
//  Created by Anton Glezman on 16/09/2019.
//

import Foundation

struct TlHelper {
    
    static func getType(_ tlType: String) -> String {
        if tlType.hasPrefix("vector") {
            let startIdx = tlType.firstIndex(of: "<")  ?? tlType.startIndex
            let endIdx = tlType.lastIndex(of: ">") ?? tlType.endIndex
            let innerType = String(tlType[tlType.index(after: startIdx)..<endIdx])
            return "[\(getType(innerType))]"
        } else if let primitive = mapPrimitiveType(tlType) {
            return primitive
        } else {
            // object type
            return tlType.capitalizedFirstLetter
        }
    }
    
    static func mapPrimitiveType(_ tlType: String) -> String? {
        let mapping = [
            "Bool": "Bool",
            "string": "String",
            "double": "Double",
            "int32": "Int",
            "int53": "Int64",
            "int64": "Int64",
            "bytes": "Data"
        ]
        return mapping[tlType]
    }
    
    static func maskSwiftKeyword(_ keyword: String) -> String {
        let keywords = ["protocol", "class", "struct", "enum"]
        if keywords.contains(keyword) {
            return "`\(keyword)`"
        }
        return keyword
    }
    
}
