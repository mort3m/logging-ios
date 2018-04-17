//
//  Log.swift
//  mySugr-Logging
//
//  Created by Florian E. on 03.04.18.
//  Copyright © 2018 Florian E. All rights reserved.
//

import Foundation


public class LoggingProvider {
    
    public static let shared = LoggingProvider()
    fileprivate var destinations: [LogDestination]
    
    public init() {
        self.destinations = [ConsoleDestination()]
    }
    
    public class func setupDestinations(_ destinations: [LogDestination]) {
        LoggingProvider.shared.destinations = destinations
    }
    
    private class func log(_ message: String, _ level: LogLevel, _ tags: [String] = [], _ additionalInformation: [String: Any]? = nil, line: Int, function: String, file: String) {
        let log = Log(message: message, level: level, function: function, file: file, line: line, tags: tags, additionalInformation: additionalInformation)
        LoggingProvider.shared.destinations.forEach {
            $0.write(log: log)
        }
    }
    
    open class func debug(_ message: String, _ tags: [String] = [], _ additionalInformation: [String: Any]? = nil, line: Int = #line, function: String = #function, file: String = #file) {
        LoggingProvider.log(message, .debug, tags, additionalInformation, line: line, function: function, file: file)
    }
    
    open class func error(_ message: String, _ tags: [String] = [], _ error: Error? = nil, line: Int = #line, function: String = #function, file: String = #file) {
        LoggingProvider.log(message, .error, tags, ["error": String(describing: error)], line: line, function: function, file: file)
    }
    
    open class func verbose(_ message: String, _ tags: [String] = [], _ additionalInformation: [String: Any]? = nil, line: Int = #line, function: String = #function, file: String = #file) {
        LoggingProvider.log(message, .verbose, tags, additionalInformation, line: line, function: function, file: file)
    }
    
    open class func warning(_ message: String, _ tags: [String] = [], _ additionalInformation: [String: Any]? = nil, line: Int = #line, function: String = #function, file: String = #file) {
        LoggingProvider.log(message, .warning, tags, additionalInformation, line: line, function: function, file: file)
    }
    
    open class func info(_ message: String, _ tags: [String] = [], _ additionalInformation: [String: Any]? = nil, line: Int = #line, function: String = #function, file: String = #file) {
        LoggingProvider.log(message, .info, tags, additionalInformation, line: line, function: function, file: file)
    }
}
