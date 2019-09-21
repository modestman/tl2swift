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
            .append(composeDto())
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
            .addLine("    func run(updateHandler: @escaping (Data) -> Void)")
            .addLine("    func queryAsync(query: TdQuery, completion: ((Data) -> Void)?)")
            .addLine("    func execute(query: TdQuery)")
            .addLine("}")
            .addBlankLine()
            .addLine("protocol TdQuery {")
            .addLine("    func makeQuery(with extra: String?) throws -> Data")
            .addLine("}")
    }
    
    private func composeDto() -> String {
        return ""
            .addLine("final class DTO<T: Codable>: Codable {")
            .addLine("    let type: String")
            .addLine("    var extra: String?")
            .addLine("    let payload: T")
            .addLine("    let encoder: JSONEncoder?")
            .addBlankLine()
            .addLine("    init(_ payload: T, encoder: JSONEncoder? = nil) {")
            .addLine("        self.payload = payload")
            .addLine("        self.encoder = encoder")
            .addLine("        let payloadType = String(describing: T.self)")
            .addLine("        self.type = payloadType.prefix(1).lowercased() + payloadType.dropFirst()")
            .addLine("    }")
            .addBlankLine()
            .addLine("    init(from decoder: Decoder) throws {")
            .addLine("        let container = try decoder.container(keyedBy: TdLibTypeCodingKeys.self)")
            .addLine("        type = try container.decode(String.self, forKey: .type)")
            .addLine("        extra = try container.decodeIfPresent(String.self, forKey: .extra)")
            .addLine("        payload = try T(from: decoder)")
            .addLine("        encoder = nil")
            .addLine("    }")
            .addBlankLine()
            .addLine("    func encode(to encoder: Encoder) throws {")
            .addLine("        var container = encoder.container(keyedBy: TdLibTypeCodingKeys.self)")
            .addLine("        try container.encode(type, forKey: .type)")
            .addLine("        try container.encodeIfPresent(extra, forKey: .extra)")
            .addLine("        try payload.encode(to: encoder)")
            .addLine("    }")
            .addLine("}")
            .addBlankLine()
            .addLine("extension DTO: TdQuery {")
            .addBlankLine()
            .addLine("    func makeQuery(with extra: String?) throws -> Data {")
            .addLine("        self.extra = extra")
            .addLine("        let encoder = self.encoder ?? JSONEncoder()")
            .addLine("        return try encoder.encode(self)")
            .addLine("    }")
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
