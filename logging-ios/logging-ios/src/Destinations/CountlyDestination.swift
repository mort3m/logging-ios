//
//  CountlyDestination.swift
//  mySugr-Logging
//
//  Created by Florian E. on 17.04.18.
//  Copyright © 2018 Florian E. All rights reserved.
//

import Foundation

public class CountlyDestination: LogDestination {
    
    public override init() {
        print("[CountlyDestination] - Setup successfully! 🎉")
    }
    
    override public func write(log: Log) {
        
    }
}
