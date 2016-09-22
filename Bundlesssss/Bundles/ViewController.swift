//
//  ViewController.swift
//  bundles
//
//  Created by Leo on 16/9/21.
//  Copyright © 2016年 Binea. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docmentDic = path[0]
        let libPath = "\(docmentDic)/HotFrameworkTest.framework"
        let frameworkBundle = NSBundle(path: libPath)
        frameworkBundle?.load()
        print("loaded:\(frameworkBundle?.loaded)")
    }
    
    @IBAction func testAction(sender: AnyObject) {
        
        if let testClass = NSClassFromString("HotFrameworkTest.HotLoadViewController") as? UIViewController.Type {
            let vc = testClass.self.init()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

