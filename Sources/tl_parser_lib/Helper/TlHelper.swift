//
//  File.swift
//  
//
//  Created by Anton Glezman on 16/09/2019.
//

import Foundation

struct TlHelper {
    
    static func getType(_ tlType: String, optional: Bool = false) -> String {
        let resultType: String
        if tlType.hasPrefix("vector") {
            let startIdx = tlType.firstIndex(of: "<")  ?? tlType.startIndex
            let endIdx = tlType.lastIndex(of: ">") ?? tlType.endIndex
            let innerType = String(tlType[tlType.index(after: startIdx)..<endIdx])
            resultType = "[\(getType(innerType))]"
        } else if let primitive = mapPrimitiveType(tlType) {
            resultType = primitive
        } else {
            // object type
            resultType = tlType.capitalizedFirstLetter
        }
        return optional ? "\(resultType)?" : resultType
    }
    
    static func mapPrimitiveType(_ tlType: String) -> String? {
        let mapping = [
            "Bool": "Bool",
            "string": "String",
            "double": "Double",
            "int32": "Int",
            "int53": "Int64",
            "int64": "String", // for decoding json
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
