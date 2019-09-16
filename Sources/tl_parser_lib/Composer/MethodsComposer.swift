//
//  File.swift
//  
//
//  Created by Anton Glezman on 15/09/2019.
//

import Foundation

class MethodsComposer: Composer {
    
    private let classInfoes: [ClassInfo]
    
    init(classInfoes: [ClassInfo]) {
        self.classInfoes = classInfoes
    }
    
    override func composeUtilitySourceCode() throws -> String {
        let methods = composeMethods(classInfoes: classInfoes)
        return ""
            .addLine("class TdClient {")
            .addBlankLine()
            .append(methods.indent())
            .addLine("}")
    }
    
    private func composeMethods(classInfoes: [ClassInfo]) -> String {
        var result = ""
        for info in classInfoes where info.isFunction {
            result = result.append(composeMethod(info))
        }
        return result
    }
    
    private func composeMethod(_ info: ClassInfo) -> String {
        var paramsList = [String]()
        for param in info.properties {
            let type = TlHelper.getType(param.type)
            let paramName = TlHelper.maskSwiftKeyword(param.name.underscoreToCamelCase())
            paramsList.append("\(paramName): \(type)")
        }
        let params = paramsList.isEmpty ? "" : (paramsList.joined(separator: ", ") + ", ")
        // TODO: add documentation comment
        return ""
            .addLine("func \(info.name)(\(params)completion: @escaping (\(info.rootName)) -> Void) {")
            .addLine("}")
            .addBlankLine()
    }
    
}

