//
//  dsettVC.swift
//  alzeeb
//
//  Created by hassan duhair on 2/14/19.
//  Copyright © 2019 abd. All rights reserved.
//

import UIKit
import GoogleMobileAds



class dsettVC: VCHavingAdvancedAD {
    func dIsSuccess(_ state: Bool) {}
    
    func dComplate(_ num: Double) {}
    
    func counter(_ totalBytesWritten: Float, totalUnitCount: Float) {}
    
    func cancel() {}
    
    func error() {}
    
    func msgAuthWrong() {}

    
    
    
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func twtterTApped(_ sender: Any) {
        let url = URL(string: "https://twitter.com/iphoneexx")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }

    
}


