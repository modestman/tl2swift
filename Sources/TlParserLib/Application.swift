//
//  Application.swift
//  tl_parser_lib
//
//  Created by Anton Glezman on 12/09/2019.
//

import Foundation

public final class Application {
    
    // MARK: - Constants
    
    private enum Constants {
        static let project = "tl2swift"
    }
    
    
    // MARK: - Private properties
    
    private let schema: Schema
    private let outputDir: URL
    private let fileWriter = FileWriter()
    
    
    // MARK: - Init
    
    public init(schema: Schema, outputDir: URL) {
        self.schema = schema
        self.outputDir = outputDir
    }
    
    
    // MARK: - Public methods
    
    /// Genarate and write swift files from `Schema`
    public func run() -> Int32 {
        do {
            let implementedUtilities = try composeUtilities()
            try fileWriter.write(implementations: implementedUtilities, verbose: true)
        } catch {
            print(error)
            return 1
        }
        return 0
    }
    
    
    // MARK: - Private methods
    
    private func composeUtilities() throws -> [Implementation] {
        let outputModelsDir = outputDir.appendingPathComponent("Models", isDirectory: true)
        let outputSupportingDir = outputDir.appendingPathComponent("Supporting", isDirectory: true)
        let apiDir = outputDir.appendingPathComponent("API", isDirectory: true)
        
        var impl = [Implementation]()
        impl += try supportingClassesImplementation(output: outputSupportingDir)
        impl += try enumsImplementation(output: outputModelsDir)
        impl += try structsImplementation(output: outputModelsDir)
        impl += try apiImplementation(output: apiDir)
        return impl
    }
    
    private func supportingClassesImplementation(output: URL) throws -> [Implementation] {
        let dto = try DtoComposer().composeEntityUtilityImplementation(
            forEntityName: "DTO",
            projectName: Constants.project,
            outputDirectory: output.path)
        
        let decoder = try DecoderHelperComposer().composeEntityUtilityImplementation(
            forEntityName: "JSONDecoder+Result",
            projectName: Constants.project,
            outputDirectory: output.path)

        let codingKeys = try CodingKeysComposer().composeEntityUtilityImplementation(
            forEntityName: "DtoCodingKeys",
            projectName: Constants.project,
            outputDirectory: output.path)
        
        let logger = try LoggerCimposer().composeEntityUtilityImplementation(
            forEntityName: "Logger",
            projectName: Constants.project,
            outputDirectory: output.path)
        
        let tdInt64 = try TdInt64Composer().composeEntityUtilityImplementation(
            forEntityName: "TdInt64",
            projectName: Constants.project,
            outputDirectory: output.path)
        
        return [dto, decoder, codingKeys, logger, tdInt64]
    }
    
    private func enumsImplementation(output: URL) throws -> [Implementation] {
        var impls = [Implementation]()
        for enumInfo in schema.enumInfoes {
            let composer = EnumComposer(enumInfo: enumInfo, schema: schema)
            let impl = try composer.composeEntityUtilityImplementation(
                forEntityName: enumInfo.enumType,
                projectName: Constants.project,
                outputDirectory: output.path)
            impls.append(impl)
        }
        return impls
    }
    
    private func structsImplementation(output: URL) throws -> [Implementation] {
        var impls = [Implementation]()
        let structs = findClassesNotAssociatedWithEnums()
        for classInfo in structs {
            let composer = StructComposer(classInfo: classInfo)
            let impl = try composer.composeEntityUtilityImplementation(
                forEntityName: classInfo.name.capitalizedFirstLetter,
                projectName: Constants.project,
                outputDirectory: output.path)
            impls.append(impl)
        }
        return impls
    }
    
    private func findClassesNotAssociatedWithEnums() -> [ClassInfo] {
        var enumClasses = [String]()
        for enumInfo in schema.enumInfoes {
            let classes = enumInfo.items.map { $0.name.lowercased() }
            enumClasses.append(contentsOf: classes)
        }
        return schema.classInfoes.filter { !enumClasses.contains($0.name.lowercased()) }
    }
    
    private func apiImplementation(output: URL) throws -> [Implementation] {
        let clientProtocol = try ClientProtocolComposer().composeEntityUtilityImplementation(
            forEntityName: "TdClient",
            projectName: Constants.project,
            outputDirectory: output.path)
        
        let composer = MethodsComposer(classInfoes: schema.classInfoes)
        let methodsImpl = try composer.composeEntityUtilityImplementation(
            forEntityName: "TdApi",
            projectName: Constants.project,
            outputDirectory: output.path)
        
        return [clientProtocol, methodsImpl]
    }
    
}
