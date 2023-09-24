//
//  ChosingServiceVC.swift
//  Hero
//
//  Created by hassan duhair on 2/3/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ChosingServiceVC: VCHavingAdvancedAD {
  
   

    @IBAction func compressTapped(_ sender: Any) {
        let vc: VCcomparessVideo = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCcomparessVideo") as! VCcomparessVideo
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cuttingTapped(_ sender: Any) {
        let vc: CuttingVideoVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CuttingVideoVC") as! CuttingVideoVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func settingTApped(_ sender: Any) {
        let vc: SettingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.present(vc, animated: true, completion: nil)
    }
    
}
