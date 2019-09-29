import Foundation
import PathKit
import TlParserLib

let args = ProcessInfo.processInfo.arguments

if args.count == 1 || args[1] == "--help" || args[1] == "-h" {
    print("Usage: \n\ttl2swift api.tl output_dir")
    exit(0)
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
