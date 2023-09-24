//
//  CuttingVideoVC.swift
//  Hero
//
//  Created by hassan duhair on 2/3/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import GoogleMobileAds

class CuttingVideoVC: UIViewController, GADFullScreenContentDelegate,adMobDelegate , CuttingDelegate, PopupDelegate{
    
    @IBOutlet weak var bannerView: GADBannerView!
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?

    var interstitial: GADInterstitialAd!
    let clsGoogleAds_Object = clsGoogleAds()

    override func viewDidLoad() {
        super.viewDidLoad()
        runAdsBaneer()
        clsGoogleAds_Object.loadGoogleAds()
        clsGoogleAds.share.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAdsForCutting), name: NSNotification.Name.init("showAdsForCutting"), object: nil)


    }
    
    @objc func showAdsForCutting(){
        self.clsGoogleAds_Object.showGoogleAds(viewController: self)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func runAdsBaneer() {
        clsGoogleAds.share.setupBannerAds(bannerView: bannerView, viewController: self, adUnitID: "ca-app-pub-3233536447139983/4254623948")
    }

    @IBAction func cutVideoTapped(_ sender: UIButton) {
        openImgPicker()
    }
    
    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func finish(success: Bool) {
        if success{
            DispatchQueue.main.sync {
                RSLoadingView.hide(from: self.view)
                let smallViewController: PopupVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
                let popupViewController = BIZPopupViewController(contentViewController: smallViewController, contentSize: CGSize(width: CGFloat(350), height: CGFloat(250)))
                popupViewController?.showDismissButton = true
                popupViewController?.enableBackgroundFade = true
                self.present(popupViewController!, animated: false, completion: nil)
            }
        }
    }
    
    func popUpDismiss() {
        self.clsGoogleAds_Object.showGoogleAds(viewController: self)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitialAd) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func settingTapped(_ sender: Any) {
        let vc: SettingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension CuttingVideoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        print("finit")
//        videoURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL
//        print("videoURL:\(String(describing: videoURL))")
//        self.dismiss(animated: true, completion: nil)
//        if let url = videoURL {
//
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        print("videoURL:\(String(describing: videoURL))")
        self.dismiss(animated: true, completion: nil)
        if let url = videoURL {
            let cutting = Cutting()
            cutting.delegate = self
            cutting.GetVideoAndTrimIt(url: url, fromVC: self)
        }

    }
}
