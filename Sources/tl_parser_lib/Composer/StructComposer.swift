//
//  File.swift
//  
//
//  Created by Anton Glezman on 15/09/2019.
//

import Foundation

class StructComposer: Composer {
    
    private let classInfo: ClassInfo
    
    
    init(classInfo: ClassInfo) {
        self.classInfo = classInfo
    }
    
    override func composeUtilitySourceCode() throws -> String {
        return composeStruct(classInfo: self.classInfo)
    }
    
    
    private func composeStruct(classInfo: ClassInfo) -> String {
        let structName = classInfo.name.capitalizedFirstLetter
        let props = composeStructProperties(classInfo.properties)
        return ""
            .addLine("/// \(classInfo.description)")
            .addLine("struct \(structName): Codable {")
            .addBlankLine()
            .append(props.indent())
            .addLine("}")
            .addBlankLine()
    }
    
    private func composeStructProperties(_ properties: [ClassProperty]) -> String {
        var result = ""
        for propertyInfo in properties {
            if let comment = propertyInfo.description {
                result = result.addLine("/// \(comment)")
            }
            let type = TlHelper.getType(propertyInfo.type)
            let propertyName = TlHelper.maskSwiftKeyword(propertyInfo.name.underscoreToCamelCase())
            result = result
                .addLine("let \(propertyName): \(type)")
                .addBlankLine()
        }
        return result
    }
    
    
}
