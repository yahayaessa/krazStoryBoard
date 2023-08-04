//
//  VCcomparessVideo.swift
//  Hero
//
//  Created by fadel sultan on 9/14/18.
//  Copyright © 2018 fadel sultan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
//import YPImagePicker
import Photos
import MobileCoreServices
//import RSLoadingView
import GoogleMobileAds

class VCcomparessVideo: NativeAdsVC,GAdsDelegate, GADFullScreenContentDelegate {
    
    @IBOutlet weak var btnStartResize: UIButton!
    @IBOutlet weak var adView: UIView!

    var imagePickerController = UIImagePickerController()
    
    var videoURL: URL?
    
    var interstitial: GADInterstitialAd!
    
    let clsGoogleAds_Object = GoogleAdsObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAd()
//        runAdsBaneer()        
    }
    override func setupAd() {
        self.nativeAdPlaceholder = adView
        super.setupAd()
        self.clsGoogleAds_Object.loadGoogleAdsInterstitial()
    }
  
    
    func runAdsBaneer() {
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
    @IBAction func btnVCSetting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "YESettingsViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
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

        IJProgressView.shared.showProgressView()

        
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
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "تم حفظ الفيديو بنجاح", message: nil, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "موافق", style: UIAlertAction.Style.default, handler: { (_) in
                                    self.dismiss(animated: true, completion: nil)
                                    IJProgressView.shared.hideProgressView()
                                    self.clsGoogleAds_Object.showInterstitial(viewController: self)
                                    // show ad
                                })
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                           
                        }else {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "The video was not saved because there are no permissions. Try again after agreeing to access the photo library", message: nil, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
                                    IJProgressView.shared.hideProgressView()
                                })
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
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
