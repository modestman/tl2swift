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
            .addLine("class TdApi {")
            .addBlankLine()
            .addLine("private let client: TdClient".indent())
            .addLine("private let encoder = JSONEncoder()".indent())
            .addLine("private let decoder = JSONDecoder()".indent())
            .addBlankLine()
            .addLine("init(client: TdClient) {".indent())
            .addLine("self.client = client".indent().indent())
            .addLine("self.encoder.keyEncodingStrategy = .convertToSnakeCase".indent().indent())
            .addLine("self.decoder.keyDecodingStrategy = .convertFromSnakeCase".indent().indent())
            .addLine("}".indent())
            .addBlankLine()
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
            paramsList.append("\(paramName): \(type),")
        }
        paramsList.append("completion: @escaping (Result<\(info.rootName), Swift.Error>) -> Void")
        
        var result = composeComment(info)
        if paramsList.count > 1 {
            let params = paramsList.reduce("", { $0.addLine("\($1)".indent()) })
            result = result
                .addLine("func \(info.name)(")
                .append(String(params.dropLast()))
                .addLine(") throws {")
        } else {
            result = result.addLine("func \(info.name)(\(paramsList.first!)) throws {")
        }
        
        // TODO: add documentation comment
        let impl = composeMethodImpl(info)
        result = result
            .addBlankLine()
            .append(impl.indent())
            .addLine("}")
            .addBlankLine()
        
        return result
    }
    
    private func composeComment(_ info: ClassInfo) -> String {
        var result = "/// \(info.description)\n"
        for param in info.properties {
            let paramName = TlHelper.maskSwiftKeyword(param.name.underscoreToCamelCase())
            result = result.addLine("/// - Parameter \(paramName): \(param.description ?? "")")
        }
        return result
    }
    
    private func composeMethodImpl(_ info: ClassInfo) -> String  {
        let structName = info.name.capitalizedFirstLetter
        var result = ""
        if info.properties.isEmpty {
            result = result.addLine("let query = \(structName)()")
        } else {
            result = result.addLine("let query = \(structName)(")
            for param in info.properties {
                let paramName = param.name.underscoreToCamelCase()
                let paramValue = TlHelper.maskSwiftKeyword(param.name.underscoreToCamelCase())
                result = result.addLine("\(paramName): \(paramValue),".indent())
            }
            result = String(result.dropLast().dropLast())
            result = result.addBlankLine().addLine(")")
        }

        return result
            .addLine("let data = try encoder.encode(query)")
            .addLine("client.queryAsync(query: data) { [weak self] result in")
            .addLine("guard let `self` = self else { return }")
            .addLine("let response = self.decoder.tryDecode(\(info.rootName).self, from: result)".indent())
            .addLine("completion(response)".indent())
            .addLine("}")
    }
}
