import Foundation
import PathKit
import tl_parser_lib

let args = ProcessInfo.processInfo.arguments

guard args.count >= 2 else {
    preconditionFailure("Invalid number of arguments")
}

let inFile = Path(args[1])
let outPath = args.count > 2 ? Path(args[2]) : Path.current

let data = try! Data(contentsOf: inFile.url)
let tl = String(data: data, encoding: .utf8)!

let parser = Parser(tl: tl)
guard let schema = parser.parse() else {
    print("Can't parse")
    exit(1)
}

let app = Application(schema: schema, outputDir: outPath.url)
exit(app.run())
