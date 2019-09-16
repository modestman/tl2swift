struct ClassInfo: Hashable {
    let name: String
    let properties: [ClassProperty]
    let description: String
    let rootName: String
    let isFunction: Bool
}

struct ClassProperty: Hashable {
    let name: String
    let type: String
    let description: String?
}

struct InterfaceInfo: Hashable {
    let name: String
    let description: String
}

struct EnumInfo: Hashable {
    let enumType: String
    var items: [EnumItem] // Case name and associated value
    let description: String
}

struct EnumItem: Hashable {
    let name: String
    let associatedClassName: String?
    let description: String
}


public final class Schema {
    
    var classInfoes: [ClassInfo] = []
    var interfaceInfoes: [InterfaceInfo] = []
    var enumInfoes: [EnumInfo] = []
    
}
