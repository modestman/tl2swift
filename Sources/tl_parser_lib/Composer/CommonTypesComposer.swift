//
//  File.swift
//  
//
//  Created by Anton Glezman on 15/09/2019.
//

import Foundation

class CommonTypesComposer: Composer {
    
    override func composeUtilitySourceCode() throws -> String {
        return ""
            .append(composeCodingKeys())
            .addBlankLine()
            .append(composeClientProtocol())
            .addBlankLine()
            .append(composeJsonDecoderExtension())
    }
    
    private func composeCodingKeys() -> String {
        return ""
            .addLine("enum TdLibTypeCodingKeys: String, CodingKey {")
            .addLine("case type = \"@type\"".indent())
            .addLine("case extra = \"@extra\"".indent())
            .addLine("}")
    }
    
    private func composeClientProtocol() -> String {
        return ""
            .addLine("protocol TdClient {")
            .addBlankLine()
            .addLine("func queryAsync(query: Data, completion: ((Data) -> Void)?)".indent())
            .addBlankLine()
            .addLine("func run(updateHandler: @escaping (Data) -> Void)".indent())
            .addBlankLine()
            .addLine("}")
    }
    
    private func composeJsonDecoderExtension() -> String {
        return ""
            .addLine("extension JSONDecoder {")
            .addLine("    func tryDecode<T>(_ type: T.Type, from data: Data) -> Result<T, Swift.Error> where T : Decodable {")
            .addLine("        do {")
            .addLine("            let result = try self.decode(type, from: data)")
            .addLine("            return .success(result)")
            .addLine("        } catch {")
            .addLine("            return .failure(error)")
            .addLine("        }")
            .addLine("    }")
            .addLine("}")
    }
}
