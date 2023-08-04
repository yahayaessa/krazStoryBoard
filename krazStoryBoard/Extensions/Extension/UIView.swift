//
//  UIView.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    @IBInspectable
    var cornersRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
    
    
    @IBInspectable
    var borderColor:  UIColor{
        get { return UIColor(cgColor: layer.borderColor!) }
        set {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth:  CGFloat{
        get { return layer.borderWidth }
        set {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var isCicler: Bool {
        get{
        return layer.masksToBounds
        }
        set{
            layer.cornerRadius = self.frame.width/2
            layer.masksToBounds = isCicler
        }        
    }
}

extension UIView {
    /**
     Convert UIView to UIImage
     */
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
}

