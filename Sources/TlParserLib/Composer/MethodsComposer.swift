//
//  File.swift
//  
//
//  Created by Anton Glezman on 15/09/2019.
//

import Foundation

final class MethodsComposer: Composer {
    
    // MARK: - Private properties
    
    private let classInfoes: [ClassInfo]
    
    
    // MARK: - Init
    
    init(classInfoes: [ClassInfo]) {
        self.classInfoes = classInfoes
    }
    
    
    // MARK: - Override
    
    override func composeUtilitySourceCode() throws -> String {
        let methods = composeMethods(classInfoes: classInfoes)
        let executeFunc = composeExecuteFunc()
        return ""
            .addLine("public final class TdApi {")
            .addBlankLine()
            .addLine("public let client: TdClient".indent())
            .addLine("public let encoder = JSONEncoder()".indent())
            .addLine("public let decoder = JSONDecoder()".indent())
            .addBlankLine()
            .addLine("public init(client: TdClient) {".indent())
            .addLine("self.client = client".indent().indent())
            .addLine("self.encoder.keyEncodingStrategy = .convertToSnakeCase".indent().indent())
            .addLine("self.decoder.keyDecodingStrategy = .convertFromSnakeCase".indent().indent())
            .addLine("}".indent())
            .addBlankLine()
            .addBlankLine()
            .append(methods.indent())
            .addBlankLine()
            .append(executeFunc.indent())
            .addLine("}")
    }
    
    
    // MARK: - Private methods
    
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
            let type = TypesHelper.getType(param.type, optional: param.optional)
            let paramName = TypesHelper.maskSwiftKeyword(param.name.underscoreToCamelCase())
            paramsList.append("\(paramName): \(type),")
        }
        paramsList.append("completion: @escaping (Result<\(info.rootName), Swift.Error>) -> Void")
        
        var result = composeComment(info)
        if paramsList.count > 1 {
            let params = paramsList.reduce("", { $0.addLine("\($1)".indent()) })
            result = result
                .addLine("public func \(info.name)(")
                .append(params)
                .addLine(") throws {")
        } else {
            result = result.addLine("public func \(info.name)(\(paramsList.first!)) throws {")
        }
        
        let impl = composeMethodImpl(info)
        result = result
            .append(impl.indent())
            .addLine("}")
            .addBlankLine()
        
        return result
    }
    
    private func composeComment(_ info: ClassInfo) -> String {
        var result = "/// \(info.description)\n"
        for param in info.properties {
            let paramName = TypesHelper.maskSwiftKeyword(param.name.underscoreToCamelCase())
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
                let paramValue = TypesHelper.maskSwiftKeyword(param.name.underscoreToCamelCase())
                result = result.addLine("\(paramName): \(paramValue),".indent())
            }
            result = String(result.dropLast().dropLast())
            result = result.addBlankLine().addLine(")")
        }

        return result.addLine("execute(query: query, completion: completion)")
    }
    
    private func composeExecuteFunc() -> String {
        return ""
            .addLine("private func execute<Q, R>(")
            .addLine("    query: Q,")
            .addLine("    completion: @escaping (Result<R, Swift.Error>) -> Void)")
            .addLine("    where Q: Codable, R: Codable {")
            .addBlankLine()
            .addLine("    let dto = DTO(query, encoder: self.encoder)")
            .addLine("    client.send(query: dto) { [weak self] result in")
            .addLine("        guard let self = self else { return }")
            .addLine("        if let error = try? self.decoder.decode(DTO<Error>.self, from: result) {")
            .addLine("            completion(.failure(error.payload))")
            .addLine("        }")
            .addLine("        let response = self.decoder.tryDecode(DTO<R>.self, from: result)")
            .addLine("        completion(response.map { $0.payload })")
            .addLine("    }")
            .addLine("}")
    }
}
