//
//  Logging.swift
//  Au3dio
//
//  Created by Valentin Knabel on 23.01.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import Foundation

private func _print(item: Any) {
    print(item)
}

public struct Log {
    public var filename: String
    public var line: Int
    public var function: String

    public init(filename: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        self.filename = filename
        self.line = line
        self.function = function
    }

    public func message(message: String) -> String {
        return "\((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)"
    }

    public func print(message: String) {
        _print(self.message(message))
    }

    public static func message(message: String, filename: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) -> String {
        return "\((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)"
    }

    public static func print(msg: String, filename: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        _print(message(msg, filename: filename, line: line, function: function))
    }
}
