//
//  ViewController.swift
//  ByteSequence
//
//  Created by REDSTATION on 4/23/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        print("I got load")
        var buffer = ByteSequence()
        buffer.append(8)
        print(buffer)
        
        let seq = ByteSequence(count: 7)
        let set = seq.partition(by: 3)
        print(set)
    }

    ///
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
