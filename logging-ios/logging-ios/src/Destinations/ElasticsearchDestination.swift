//
//  ElasticsearchDestination.swift
//  mySugr-Logging
//
//  Created by Florian E. on 04.04.18.
//  Copyright © 2018 Florian E. All rights reserved.
//

import Foundation

public typealias ElasticsearchCredentials = (username: String, password: String)

public class ElasticsearchDestination: LogDestination {
    
    private let pointSendThreshold = 10
    
    private var logQueue: [Log] = []
    private let elasticsearchUrl: URL
    private let credentials: ElasticsearchCredentials?
    private var sendDataTimer: Timer?
    
    public init(url: URL, credentials: ElasticsearchCredentials? = nil) {
        self.elasticsearchUrl = url.appendingPathComponent("v1/log/add")
        self.credentials = credentials
        super.init()
        
        self.sendDataTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(persistInElasticsearch), userInfo: nil, repeats: true)
        
        print("[ElasticsearchDestination] - Setup successfully! 🎉")
    }
    
    public override func write(log: Log) {
        self.logQueue.append(log)
        self.evaluatePoints()
    }
    
    private func evaluatePoints() {
        
        var points = 0
        
        self.logQueue.forEach {
            points += $0.level.points
        }
        
        if points >= pointSendThreshold {
            persistInElasticsearch()
        }
    }
    
    @objc private func persistInElasticsearch() {
        
        if self.logQueue.count == 0 { return }

        do {
            let requestData = try JSONEncoder().encode(self.logQueue)
            self.logQueue.removeAll()
            
            self.sendPOSTRequest(data: requestData, endpoint: self.elasticsearchUrl) {
                if let error = $0 {
                    print("[ElasticsearchDestination] - Error: \(error)")
                }
            }
        } catch {
            print("[ElasticsearchDestination] - Error: \(error)")
        }
    }
    
    private func sendPOSTRequest(data: Data, endpoint: URL, completion: @escaping (Error?) -> Void) {
        
        print(String(data: data, encoding: .utf8))
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.timeoutInterval = 10.0
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        request.httpBody = data

        let config = URLSessionConfiguration.default
        
        if let credentials = self.credentials {
            guard let authString = "\(credentials.username):\(credentials.password)".toBase64() else {
                assertionFailure("There was a problem while encoding base64")
                return
            }
            
            config.httpAdditionalHeaders = ["Authorization" : "Basic \(authString)"]
        }
        
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if let error = responseError {
                completion(error)
                return
            } else {
                self.logQueue = []
                completion(nil)
            }
            
            print(String(data: responseData!, encoding: .utf8))
        }
        
        task.resume()
    }
}

fileprivate extension String {
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        return data.base64EncodedString()
    }
}
