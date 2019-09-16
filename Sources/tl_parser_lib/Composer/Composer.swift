//
//  Composer.swift
//  tl_parser_lib
//
//  Created by Anton Glezman on 15/09/2019.
//

import Foundation

/**
 Abstract class responsible for composing source code.
 
 Implements header comment generation with copyright information and imports Foundation into
 generated code.
 
 Provides basic utility class structure separation, allows to override utility class filename
 generation, allows to extend imports and implement source code generation.
 */
open class Composer {
    
    /**
     Compose utility class source code.
     
     - parameter entityKlass: entity class model for which utility should be composed;
     - parameter entityKlasses: other entity classes available in scope;
     - parameter projectName: project name.
     
     - returns: `Implementation` object with utility class source code and filename.
     */
    public func composeEntityUtilityImplementation(
        forEntityName entityName: String,
        projectName: String,
        outputDirectory: String
    ) throws -> Implementation {
        let filename: String = composeEntityUtilityFilename(entityName)
        let path: String = outputDirectory.hasSuffix("/") ? outputDirectory + filename : outputDirectory + "/" + filename
        let sourceCode: String =
            try
                composeCopyrightComment(forFilename: filename, project: projectName).addBlankLine() +
                composeImports().addBlankLine().addBlankLine() +
                composeUtilitySourceCode()
        
        return Implementation(
            filePath: path,
            sourceCode: sourceCode
        )
    }
    
    /**
     Compose utility class filename.
     
     - parameter entityKlass: entity class model for which utility is composed.
     
     - returns: By default, returns entity class name + "Util.swift".
     */
    open func composeEntityUtilityFilename(_ filename: String) -> String {
        return "\(filename).swift"
    }
    
    /**
     Compose copytight comment header.
     
     - returns: Comment with project & file names, "Created by Code Generator" and
     "Copyright RedMadRobot".
     */
    open func composeCopyrightComment(forFilename filename: String, project: String) -> String {
        return ""
            .addLine("//")
            .addLine("//  \(filename)")
            .addLine("//  \(project)")
            .addLine("//")
            .addLine("//  Created by Code Generator")
            .addLine("//")
    }
    
    /**
     Compose import declarations.
     
     - returns: `import Foundation` by default.
     */
    open func composeImports() -> String {
        return ""
            .addLine("import Foundation")
    }
    
    /**
     Abstract method to compose utility class source code.
     
     - parameter entityKlass: entity class model for which utility is composed;
     - parameter entityKlasses: other entity classes available in scope.
     
     - returns: Utility class body source code withoud class declaration.
     */
    open func composeUtilitySourceCode() throws -> String {
        return ""
    }
    
}
