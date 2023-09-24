//
//  MyAlert.swift
//  Hero
//
//  Created by hassan duhair on 2/3/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import UIKit

class MyAlert{
    
    private let vc: UIViewController!
    var delegate: MyAlertDelegate!
    
    init(vc: UIViewController){
        self.vc = vc
    }
    
    func show(){
        let alert = UIAlertController.init(title: "اختر الخدمة", message: "من فضلك اختار الخدمة التي تريدها", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "ضفط فيديو", style: .default, handler: { (action) in
            self.delegate.didSelectServiceWithId(0)
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "تقطيع فيديو", style: .default, handler: { (action) in
            self.delegate.didSelectServiceWithId(1)
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "اغلاق", style: .destructive, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
}

protocol MyAlertDelegate {
    func didSelectServiceWithId(_ service_id: Int)
}
