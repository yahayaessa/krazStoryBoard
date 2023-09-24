//
//  VCcomparessVideo.swift
//  alzeeb
//
//  Created by hassan duhair on 2/14/19.
//  Copyright © 2019 abd. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit
import YPImagePicker
import Photos
import MobileCoreServices
import GoogleMobileAds



class VCcomparessVideo: UIViewController,adMobDelegate, GADFullScreenContentDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var interstitial: GADInterstitialAd!
    let clsGoogleAds_Object = clsGoogleAds()
    var myPopupView:popupView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runAdsBaneer()
        clsGoogleAds_Object.loadGoogleAds()
        clsGoogleAds.share.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAdsForCompress), name: NSNotification.Name.init("showAdsForCompress"), object: nil)
        
    }
    
    //    @IBAction func doneTapped(_ sender: Any) {
    //        UIView.animate(withDuration: 1) {
    //            self.backgroudView.isHidden = true
    //            self.popupView.isHidden = true
    //        }
    //    }
    
    @IBAction func settingTapped(_ sender: Any) {
        let vc: SettingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func runAdsBaneer() {
        clsGoogleAds.share.setupBannerAds(bannerView: bannerView, viewController: self, adUnitID: "ca-app-pub-3233536447139983/4254623948")
    }
    
    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectVideoToComparess(_ sender: Any) {
        openImgPicker()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitialAd) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension VCcomparessVideo : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        videoURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL
        print("videoURL:\(String(describing: videoURL))")
        comparessVideoBy(videoURL: videoURL!)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension VCcomparessVideo {
    func comparessVideoBy(videoURL:URL) {
        let loadingView = RSLoadingView()
        loadingView.show(on: self.view)
        
        guard let data = NSData(contentsOf: videoURL) else {
            return
        }
        
        print("File size before compression: \(Double(data.length / 1048576)) mb")
        
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
        
        self.compressVideo(inputURL: videoURL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                print("unknown")
                break
            case .waiting:
                print("waiting")
                break
            case .exporting:
                print("exporting")
                break
            case .completed:
                
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: compressedURL)
                }) { saved, error in
                    if saved {
                        /// here show popup message
                        
                        DispatchQueue.main.sync {
                            RSLoadingView.hide(from: self.view)
                            let smallViewController: PopupVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
                            smallViewController.isFromCompress = true
                            let popupViewController = BIZPopupViewController(contentViewController: smallViewController, contentSize: CGSize(width: CGFloat(350), height: CGFloat(250)))
                            popupViewController?.showDismissButton = true
                            popupViewController?.enableBackgroundFade = true
                            self.present(popupViewController!, animated: false, completion: nil)
                        }
                        
                    }else {
                        let alertController = UIAlertController(title: "The video was not saved because there are no permissions. Try again after agreeing to access the photo library", message: nil, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
                            RSLoadingView.hide(from: self.view)
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                print("failed")
                break
            case .cancelled:
                print("cancelled")
                break
            }
        }
    }
}


extension VCcomparessVideo{
    @objc func showAdsForCompress(){
        self.clsGoogleAds_Object.showGoogleAds(viewController: self)
    }
    
    func popUpDismiss() {
        RSLoadingView.hide(from: self.view)
        // show ad
        self.clsGoogleAds_Object.showGoogleAds(viewController: self)
    }
}


extension VCcomparessVideo  {
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            
            handler(exportSession)
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
