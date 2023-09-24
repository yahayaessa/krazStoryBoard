//
//  popupView.swift
//  Hero
//
//  Created by hassan duhair on 2/12/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit

@IBDesignable class popupView: UIView {
    
    var view:UIView!
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var dismissPressed: UIButton!
    
    func loadViewFromNib() -> UIView {
        
//        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "popupView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        return view
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        xibSetup()
    }
    
}
