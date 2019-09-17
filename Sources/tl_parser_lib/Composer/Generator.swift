//
//  Generator.swift
//  tl_parser_lib
//
//  Created by Anton Glezman on 12/09/2019.
//

import Foundation

public final class Generator {
    
    let schema: Schema
    let outputDir: URL
    
    public init(schema: Schema, outputDir: URL) {
        self.schema = schema
        self.outputDir = outputDir
    }
    
    public func run() throws {
        try composeCommons()
        try composeEnums()
        try composeStructs()
        try composeMethods()
    }
    
    public func composeCommons() throws {
        let composer = CommonTypesComposer()
        let impl = try composer.composeEntityUtilityImplementation(
            forEntityName: "CommonTypes",
            projectName: "tl2swift",
            outputDirectory: outputDir.path)
        try impl.sourceCode.write(toFile: impl.filePath, atomically: false, encoding: String.Encoding.utf8)
    }
    
    public func composeEnums() throws {
        for enumInfo in schema.enumInfoes {
            let composer = EnumComposer(enumInfo: enumInfo, schema: schema)
            let impl = try composer.composeEntityUtilityImplementation(
                forEntityName: enumInfo.enumType,
                projectName: "tl2swift",
                outputDirectory: outputDir.path)
            try impl.sourceCode.write(toFile: impl.filePath, atomically: false, encoding: String.Encoding.utf8)
        }
    }
    
    public func composeStructs() throws {
        let structs = findClassesNotAssociatedWithEnums()
        for classInfo in structs /* where !classInfo.isFunction */ {
            let composer = StructComposer(classInfo: classInfo)
            let impl = try composer.composeEntityUtilityImplementation(
                forEntityName: classInfo.name.capitalizedFirstLetter,
                projectName: "tl2swift",
                outputDirectory: outputDir.path)
            try impl.sourceCode.write(toFile: impl.filePath, atomically: false, encoding: String.Encoding.utf8)
        }
    }
    
    private func findClassesNotAssociatedWithEnums() -> [ClassInfo] {
        var enumClasses = [String]()
        for enumInfo in schema.enumInfoes {
            let classes = enumInfo.items.map { $0.name.lowercased() }
            enumClasses.append(contentsOf: classes)
        }
        return schema.classInfoes.filter { !enumClasses.contains($0.name.lowercased()) }
    }
    
    private func composeMethods() throws {
        let composer = MethodsComposer(classInfoes: schema.classInfoes)
        let impl = try composer.composeEntityUtilityImplementation(
            forEntityName: "TdApi",
            projectName: "tl2swift",
            outputDirectory: outputDir.path)
        try impl.sourceCode.write(toFile: impl.filePath, atomically: false, encoding: String.Encoding.utf8)
    }
}
