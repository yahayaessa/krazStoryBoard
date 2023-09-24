//
//  SettingVC.swift
//  Hero
//
//  Created by hassan duhair on 2/11/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//


import UIKit
import GoogleMobileAds

class SettingVC: VCHavingAdvancedAD {
 
    @IBAction func btnTwitter(_ sender: Any) {
        let url = URL(string: "https://twitter.com/iphoneexx")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    @IBAction func btnCloseVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
