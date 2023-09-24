//
//  PopupVC.swift
//  Hero
//
//  Created by hassan duhair on 2/10/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit


protocol PopupDelegate {
    func popUpDismiss()
}


class PopupVC: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    var isFromCompress = false
    var delegate: PopupDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromCompress {
            lbl.text = "تم ضغط الفديو بنجاح"
        }
    }
    
    @IBAction func dismesBtn(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.isFromCompress {
                NotificationCenter.default.post(name: NSNotification.Name.init("showAdsForCompress"), object: nil)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name.init("showAdsForCutting"), object: nil)
            }
        }
    }

}
