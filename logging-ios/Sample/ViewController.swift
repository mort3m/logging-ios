//
//  ViewController.swift
//  Sample
//
//  Created by Florian E. on 17.04.18.
//  Copyright © 2018 Florian E. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        log.debug("🧐", ["LOGI-3250"], ["whatever": 13])
        log.info("Sup?")
        
        do {
            let fileHandle = try FileHandle(forWritingTo: URL(string: "/")!)
        } catch {
            log.error("This should never happen.. jk", ["LOGI-3250"])
        }
    }
}

