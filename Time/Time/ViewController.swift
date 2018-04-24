//
//  ViewController.swift
//  Time
//
//  Created by REDSTATION on 4/20/18.
//  Copyright © 2018 HypeVR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTimeDistance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testTimeDistance() {
        let now = Time()
        let currentTime = DispatchTime.now()
        for t in 10 ... 30 {
            print("currentTime + t :\((currentTime + .seconds(t)).uptimeNanoseconds/1000000000)")
            sleep(1)
            let later = Time()
            let mircoSecDiff = now.distance(to: later)
            print("later: \(later.seconds), mirco diff: \(mircoSecDiff) second diff: \(mircoSecDiff/1000000)")
        }
        
    }


}

