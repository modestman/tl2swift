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
            .addLine("enum TdLibTypeCodingKeys: String, CodingKey {")
            .addLine("case type = \"@type\"".indent())
            .addLine("case extra = \"@extra\"".indent())
            .addLine("}")
    }
    
}
