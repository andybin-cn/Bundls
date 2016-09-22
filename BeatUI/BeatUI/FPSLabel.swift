//
//  FPSLabel.swift
//  Common
//
//  Created by Leo on 16/9/20.
//  Copyright © 2016年 envy.chen. All rights reserved.
//

import UIKit

public class FPSLabel: UILabel {
    private var displayLink: CADisplayLink!
    private var lastTime: CFTimeInterval = 0
    private var displayCount: Int = 0
    private let frameInterval = 20
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        displayLink = CADisplayLink(target: self, selector: #selector(tick(_:)))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.frameInterval = frameInterval
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tick(link: CADisplayLink) -> Void {
        if (lastTime == 0) {
            lastTime = link.timestamp;
            return;
        }
        
        displayCount += frameInterval
        let delta = link.timestamp - lastTime
        if (delta < 1) {
            return
        }
        lastTime = link.timestamp
        let fps = CFTimeInterval(displayCount) / delta
        displayCount = 0
        self.text = "fps: \(fps)"
    }
}
