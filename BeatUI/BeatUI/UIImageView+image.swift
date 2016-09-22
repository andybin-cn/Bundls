//
//  UIImageView+image.swift
//  Student
//
//  Created by Leo on 16/9/20.
//  Copyright © 2016年 envy.chen. All rights reserved.
//

import Foundation

private var oprationeKey: UInt = 0
private var originalImageKey: UInt = 0
private var renderSizeKey: UInt = 0
private var renderRadiusKey: UInt = 0
private var shouldRenderCircularKey: UInt = 0

extension UIImageView {
    
    func ui_roundImage(url: NSURL, roundRadius: CGFloat) {
        sd_setImageWithURL(url) { [weak self] (image, _, _, _) in
            self?.ui_roundImage(image: image, roundRadius: roundRadius)
        }
    }
    
    func ui_roundImage(image image: UIImage, roundRadius: CGFloat) {
        let size = self.bounds.size
        objc_setAssociatedObject(self, &originalImageKey, image, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &renderSizeKey, NSValue(CGSize: size), .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &renderRadiusKey, roundRadius, .OBJC_ASSOCIATION_ASSIGN)
        
        self.image = nil
        let opration = NSBlockOperation(block: {  [weak self] in
            let roundImage = image.ui_drawRectWithRoundedCorner(radius: roundRadius, sizetoFit: size)
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.image = roundImage
            })
        })
        objc_setAssociatedObject(self, &oprationeKey, opration, .OBJC_ASSOCIATION_RETAIN)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            opration.start()
        }
    }
    
    func ui_cancelLoading() {
        sd_cancelCurrentImageLoad()
        opration()?.cancel()
        objc_setAssociatedObject(self, &oprationeKey, nil, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func opration() -> NSBlockOperation? {
        return objc_getAssociatedObject(self, &oprationeKey) as? NSBlockOperation ?? nil
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layoutSubviews()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let oldSize = (objc_getAssociatedObject(self, &renderSizeKey) as? NSValue)?.CGSizeValue() ?? CGSizeZero
        if CGSizeEqualToSize(oldSize, self.bounds.size) {
            return
        }
        guard let image = objc_getAssociatedObject(self, &originalImageKey) as? UIImage else {
            return
        }
        objc_setAssociatedObject(self, &renderSizeKey, NSValue(CGSize: self.bounds.size), .OBJC_ASSOCIATION_RETAIN)
        let roundRadius = objc_getAssociatedObject(self, &renderRadiusKey) as? CGFloat ?? 5
        self.ui_roundImage(image: image, roundRadius: roundRadius)
    }
}