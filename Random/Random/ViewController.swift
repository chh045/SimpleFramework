//
//  ViewController.swift
//  Random
//
//  Created by REDSTATION on 4/18/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tester() {
        print("\(RandomG.rand() as Int8), Int8")
        print("\(RandomG.rand() as Int16), Int16")
        print("\(RandomG.rand() as Int32), Int32")
        print("\(RandomG.rand() as Int64), Int64")
        print("\(RandomG.rand() as UInt), UInt")
        print("\(RandomG.rand() as UInt8), UInt8")
        print("\(RandomG.rand() as UInt16), UInt16")
        print("\(RandomG.rand() as UInt32), UInt32")
        print("\(RandomG.rand() as UInt64), UInt64")
        print("\(RandomG.rand() as Double), Double")
        print("\(RandomG.rand() as Float), Float")
        print("\(RandomG.rand() as Bool), Bool")
        print("\(RandomG.rand(8) as String), String")
    }
}

