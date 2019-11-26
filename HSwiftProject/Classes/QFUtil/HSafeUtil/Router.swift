// Playing with router pattern in Swift. Paste to a playground.
//
// This code is in public domain, feel free to copy/paste.

import UIKit

//extension NSScanner {
//    func scanUpToString(string: String) -> String? {
//        var result: NSString? = nil
//        if scanUpToString(string, intoString: &result) {
//            return result as? String
//        }
//        return nil
//    }
//
//    func scanUpToCharactersFromSet(set: NSCharacterSet) -> String? {
//        var result: NSString? = nil
//        if scanUpToCharactersFromSet(set, intoString: &result) {
//            return result as? String
//        }
//        return nil
//    }
//}
//
//public protocol Parameter {
//    var shouldCaptureValue: Bool { get }
//    var parameterName: String? { get }
//    func fetchFrom(scanner: NSScanner) -> Any?
//}
//
//extension String: Parameter {
//    public var shouldCaptureValue: Bool { return false }
//
//    public var parameterName: String? { return nil }
//
//    public func fetchFrom(scanner: NSScanner) -> Any? {
//        let whitespaceAndNewline = NSCharacterSet.whitespaceAndNewlineCharacterSet()
//        guard let word = scanner.scanUpToCharactersFromSet(whitespaceAndNewline) else {
//            return nil
//        }
//        print("String:Parameter: self=\(self), word=\(word)")
//        return self.hasPrefix(word) ? word : nil
//    }
//}
//
//public class Word: Parameter {
//
//    init(_ parameterName: String? = nil, capture: Bool = true) {
//        self.parameterName = parameterName
//        self.shouldCaptureValue = capture
//    }
//
//    public let shouldCaptureValue: Bool
//    public var parameterName: String?
//
//    public func fetchFrom(scanner: NSScanner) -> Any? {
//        let whitespaceAndNewline = NSCharacterSet.whitespaceAndNewlineCharacterSet()
//        guard let word = scanner.scanUpToCharactersFromSet(whitespaceAndNewline) else {
//            return nil
//        }
//        print("Word:Parameter: self=\(self), word=\(word)")
//        return word
//    }
//}
//
//public class RestOfString: Parameter {
//
//    init(_ parameterName: String? = nil, capture: Bool = true) {
//        self.parameterName = parameterName
//        self.shouldCaptureValue = capture
//    }
//
//    public let shouldCaptureValue: Bool
//    public var parameterName: String?
//
//    public func fetchFrom(scanner: NSScanner) -> Any? {
//        guard let restOfString = scanner.scanUpToString("") else {
//            return nil
//        }
//        print("RestOfString:Parameter: self=\(self), restOfString=\(restOfString)")
//        return restOfString
//    }
//}
//
//public class Arguments {
//    func append(argument: Any, named name: String?) {
//        ordered.append(argument)
//        if let name = name {
//            byName[name] = argument
//        }
//    }
//
//    public func array() -> [Any] {
//        return ordered
//    }
//
//    public subscript(name: String) -> Any {
//        return byName[name]
//    }
//
//    var first: Any? { return ordered.first }
//    var last: Any? { return ordered.last }
//    var isEmpty: Bool { return ordered.isEmpty }
//
//    var ordered = [Any]()
//    var byName = [String: Any]()
//}
//
//extension Arguments: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        var orderedString = ""
//        for argument in ordered {
//            if orderedString.isEmpty {
//                orderedString = "\(argument)"
//            } else {
//                orderedString += ", \(argument)"
//            }
//        }
//
//        var byNameString = ""
//        for argument in byName {
//            if byNameString.isEmpty {
//                byNameString = "\(argument.0):\(argument.1)"
//            } else {
//                byNameString += ", \(argument.0):\(argument.1)"
//            }
//        }
//
//        return "Arguments(ordered: [\(orderedString)], named: [\(byNameString)])"
//    }
//}
//
//public class Path {
//    public typealias Handler = (Arguments)->(Bool)
//
//    public var parameters: [Parameter]
//    public var handler: Handler
//
//    init (parameters: [Parameter], handler: Path.Handler) {
//        self.parameters = parameters
//        self.handler = handler
//    }
//}
//
//public class Router {
//    public var allowPartialMatch: Bool = false
//
//    public func addPath(path: Path) {
//        paths.append(path)
//    }
//
//    public func addPath(parameters: [Parameter], _ handler: Path.Handler) {
//        let path = Path(parameters: parameters, handler: handler)
//        paths.append(path)
//    }
//
//    public func processString(string: String) -> Bool {
//        let scanner = NSScanner(string: string)
//
//        for path in paths {
//            if let arguments = fetchArgumentsInPath(path, withScanner: scanner) {
//                if path.handler(arguments) {
//                    return true
//                }
//            }
//        }
//        return false
//    }
//
//    func fetchArgumentsInPath(path: Path, withScanner scanner: NSScanner) -> Arguments? {
//        let originalScanLocation = scanner.scanLocation
//        defer {
//            scanner.scanLocation = originalScanLocation
//        }
//
//        let arguments = Arguments()
//
//        for parameter in path.parameters {
//            guard let argument = parameter.fetchFrom(scanner) else {
//                return nil
//            }
//            if parameter.shouldCaptureValue {
//                arguments.append(argument, named: parameter.parameterName)
//            }
//        }
//
//        if !allowPartialMatch {
//            return scanner.atEnd ? arguments : nil
//        }
//
//        return arguments
//    }
//
//    var paths = [Path]()
//}
//
//public class TaskController {
//    public func addTask(arguments: Arguments) -> Bool {
//        print("!!! addTask called: arguments: \(arguments)")
//        return true
//    }
//
//    public func listTasks(arguments: Arguments) -> Bool {
//        print("!!! listTasks called: arguments: \(arguments)")
//        return true
//    }
//}
//
//func help(arguments: Arguments) -> Bool {
//    print("!!! help: arguments: \(arguments)")
//    return true
//}
//
//func appVersion(arguments: Arguments) -> Bool {
//    print("!!! appVersion: arguments: \(arguments)")
//    return true
//}
//
//let taskController = TaskController()
//
//let router = Router()
//router.addPath(["help"], help)
//router.addPath(["version"], appVersion)
//router.addPath(["task", "new", Word("name"), RestOfString("description")], taskController.addTask)
//router.addPath(["task", "list"]) { arguments in
//    return taskController.listTasks(arguments)
//}
//if !router.processString("t new TestTask My test task") {
//    print("Route not found")
//}
//
//print("End")
