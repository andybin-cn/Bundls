//
//  ViewController.swift
//  bundles
//
//  Created by Leo on 16/9/21.
//  Copyright © 2016年 Binea. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import ZipArchive

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://od37lb4m5.bkt.clouddn.com/HotFrameworkTest.framework.zip
    }
    
    
    @IBAction func download(sender: AnyObject) {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docmentDic = path[0]
        let libPath = "\(docmentDic)/HotFrameworkTest"
//        NSFileManager.defaultManager()
        
        
        let destination: Request.DownloadFileDestination = { _ in
            return NSURL(fileURLWithPath:  "\(libPath).zip")
        }
        
        Manager.sharedInstance.download(.GET, "http://od37lb4m5.bkt.clouddn.com/HotFrameworkTest.framework.zip", destination: destination).response { (req, resp, _, _) in
            SSZipArchive.unzipFileAtPath("\(libPath).zip", toDestination: "\(libPath).framework")
            let frameworkBundle = NSBundle(path: "\(libPath).framework")
            frameworkBundle?.load()
            print("loaded:\(frameworkBundle?.loaded)")
        }
    }
    
    @IBAction func testAction(sender: AnyObject) {
//        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let docmentDic = path[0]
//        let libPath = "\(docmentDic)/HotFrameworkTest.framework"
//        let frameworkBundle = NSBundle(path: libPath)
//        frameworkBundle?.load()
//        print("loaded:\(frameworkBundle?.loaded)")
        
        if let testClass = NSClassFromString("HotFrameworkTest.HotLoadViewController") as? UIViewController.Type {
            let vc = testClass.self.init()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

