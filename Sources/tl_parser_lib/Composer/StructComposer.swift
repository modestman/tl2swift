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
            let type = TlHelper.getType(propertyInfo.type, optional: propertyInfo.optional)
            let propertyName = TlHelper.maskSwiftKeyword(propertyInfo.name.underscoreToCamelCase())
            result = result
                .addLine("let \(propertyName): \(type)")
                .addBlankLine()
        }
        return result
    }
    
    private func composeCodable(_ classInfo: ClassInfo) -> String {
        let codingKeys = composeCodingKeys(classInfo.properties)
        let encoder = composeEncoder(classInfo.properties)
        return ""
            .addLine("let _type = \"\(classInfo.name)\"")
            .addLine("var _extra: String? = nil")
            .addBlankLine()
            .append(codingKeys)
            .addBlankLine()
            .append(encoder)
    }
    
    private func composeCodingKeys(_ properties: [ClassProperty]) -> String {
        var result = ""
            .addLine("private enum CodingKeys: String, CodingKey {")
            .addLine("case _type = \"@type\"".indent())
            .addLine("case _extra = \"@extra\"".indent())
        
        for propertyInfo in properties {
            let caseName = TlHelper.maskSwiftKeyword(propertyInfo.name.underscoreToCamelCase())
            let caseValue = propertyInfo.name
            result = result
                .addLine("case \(caseName) = \"\(caseValue)\"".indent())
        }
        return result.addLine("}")
    }
    
    private func composeEncoder(_ properties: [ClassProperty]) -> String {
        var result = ""
            .addLine("public func encode(to encoder: Encoder) throws {")
            .addLine("var container = encoder.container(keyedBy: CodingKeys.self)".indent())
            .addLine("try container.encode(_type, forKey: ._type)".indent())
            .addLine("try container.encodeIfPresent(_extra, forKey: ._extra)".indent())
        
        for propertyInfo in properties {
            let propName = TlHelper.maskSwiftKeyword(propertyInfo.name.underscoreToCamelCase())
            result = result
                .addLine("try container.encode(\(propName), forKey: .\(propName))".indent())
        }
        
        return result.addLine("}")
    }
    
}
