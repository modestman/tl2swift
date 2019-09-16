//
//  Implementation.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 09.03.29.
//  Copyright © 29 Heisei RedMadRobot LLC. All rights reserved.
//


import Foundation


/**
 Source code implementation.
 
 After compilation, `Klass` instances are used to generate utilities. Generated source code of these
 utilities is organised into `Implementation` instances.
 */
public struct Implementation: Equatable {

    /**
     File path for future Swift class.
     */
    public let filePath:   String

    /**
     Source code.
     */
    public let sourceCode: String

    /**
     Initializer.
     */
    public init(filePath: String, sourceCode: String) {
        self.filePath = filePath
        self.sourceCode = sourceCode
    }

}

public func ==(left: Implementation, right: Implementation) -> Bool {
    return left.filePath   == right.filePath
        && left.sourceCode == right.sourceCode
}
