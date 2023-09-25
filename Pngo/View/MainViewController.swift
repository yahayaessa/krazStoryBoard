//
//  ViewController.swift
//  Hero
//
//  Created by fadel sultan on 8/19/18.
//  Copyright © 2018 fadel sultan. All rights reserved.
//

import UIKit
import PopupDialog
import Photos
import Foundation
import GoogleMobileAds
import SwiftyRate
import Alamofire
import AVFAudio
import AVFoundation
import AVKit
import StoreKit
import Loady
import Firebase

var userDefaults = UserDefaults.standard
var AUTOSAVE = "AUTOSAVE"
class MainViewController: VCHavingAdvancedAD , MZDownloadManagerDelegate  {
    
 

    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        if downloadManager.downloadingArray.count - 1 == index {
            self.downloadButton.progress += CGFloat(downloadModel.progress)
            
            if downloadModel.progress == 1{
                if self.downloadButton.state == .downloading {
                    self.fileURL = ""
                }
                var percent : CGFloat = 0
                DispatchQueue.main.async {
                    self.downloadButton.state = .downloaded
                }

                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                    percent += 1
                    if percent == 3{
                        DispatchQueue.main.async {
                            self.downloadButton.state = .startDownload
                        }
                    }
                }
                    
                
            }
        }
        
    }
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
//        MZDownloadModel.
//        if downloadManager.downloadingArray.count - 1 == index {
            self.AUTOSAVEBOOL = userDefaults.bool(forKey: AUTOSAVE)
            if self.AUTOSAVEBOOL{
                saveVideoToLibrary(URL(fileURLWithPath: downloadModel.destinationPath+"/"+downloadModel.fileName))
            }
//        }
      
    }
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [MZDownloadModel]) {
        
    }
    func saveVideoToLibrary(_ urlVideo:URL) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.save(urlVideo)
                } else {
                    
                }
            })
        }else{
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    self.save(urlVideo)
                } else {
                    
                }
            }
        }
    }
    
    
    func save(_ urlVideo:URL){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: urlVideo)
        }) { saved, error in
            if saved {
                
                var percent : CGFloat = 0
                DispatchQueue.main.async {
                    self.downloadedlabel.text = "SAVED IN PHOTO LIBRARY DONE"
                    self.downloadedlabel.isHidden = false
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                        percent += 1
                        if percent == 3{
                            DispatchQueue.main.async {
                                self.downloadedlabel.isHidden = true
                            }
                        }
                    }
                }
               
            }else {
                var percent : CGFloat = 0
                DispatchQueue.main.async {
                    self.downloadedlabel.text = "SAVED IN PHOTO LIBRARY ERROR"
                    self.downloadedlabel.isHidden = false
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                        percent += 1
                        if percent == 3{
                            DispatchQueue.main.async {
                                self.downloadedlabel.isHidden = true
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var downloadedlabel: UILabel!
    @IBOutlet weak var downloadButton: AHDownloadButton!

    
    @IBOutlet weak var viewBanner: GADBannerView!


//    @IBOutlet weak var btnStartDownload: LoadyButton!

    var AUTOSAVEBOOL :Bool = false

    var fileURL :String = ""
    var downloadedFilesArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setGradientBackground()
//        self.appstore.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
//        self.btnStartDownload.setAnimation(LoadyAnimationType.circleAndTick())
//        self.btnStartDownload?.backgroundFillColor = UIColor.gray.withAlphaComponent(0.8)
//        self.btnStartDownload?.indicatorViewStyle = .light
//        self.btnStartDownload.loadingColor = UIColor.white
//        self.btnStartDownload.borderWidth = 8
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
               downloadManager.delegate = self
               let appcolor = UIColor(named: "appColor") ?? .blue
               downloadButton.delegate = self
               downloadButton.startDownloadButtonTitle = "DOWNLOAD"
               downloadButton.startDownloadButtonTitleFont = UIFont.boldSystemFont(ofSize: 35)
               downloadButton.startDownloadButtonTitleSidePadding = 40
               downloadButton.startDownloadButtonHighlightedTitleColor = appcolor
               downloadButton.startDownloadButtonNonhighlightedTitleColor = appcolor

//               downloadButton.startDownloadButtonHighlightedBackgroundColor = .white
//               downloadButton.startDownloadButtonNonhighlightedBackgroundColor = .white
               downloadButton.pendingCircleColor = appcolor
               downloadButton.pendingCircleLineWidth = 8
               downloadButton.downloadingButtonCircleLineWidth = 8
               downloadButton.downloadingButtonHighlightedStopViewColor = appcolor
               downloadButton.downloadingButtonNonhighlightedStopViewColor = appcolor
               downloadButton.downloadingButtonHighlightedProgressCircleColor = .black.withAlphaComponent(0.6)
               downloadButton.downloadingButtonNonhighlightedProgressCircleColor = .black.withAlphaComponent(0.6)

//               downloadButton.backgroundColor = .white
               downloadButton.downloadedButtonTitle = "DOWNLOADED"
               downloadButton.downloadedButtonTitleFont = UIFont.boldSystemFont(ofSize: 35)
               downloadButton.downloadedButtonTitleSidePadding = 40
               downloadButton.downloadedButtonHighlightedTitleColor = appcolor
//               downloadButton.downloadedButtonHighlightedBackgroundColor = .white
               downloadButton.downloadedButtonNonhighlightedTitleColor = appcolor
//               downloadButton.downloadedButtonNonhighlightedBackgroundColor = .white
        setupRateApp()
//        self.setupAd()
        downloadButton.didTapDownloadButtonAction = { button,status in
            Analytics.logEvent("main_view", parameters: ["click":"did_tap_download_button_action"])
            if status == .startDownload {
            let url = UIPasteboard.general.string

            if !self.validatUrl(urlString: url) {
                self.messageWrong("الرابط المدخل غير صحيح !")
                self.reset()
                return
            }
                self.getUrl(url ?? "")

                self.reset()
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.AUTOSAVEBOOL = userDefaults.bool(forKey: AUTOSAVE)
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.AUTOSAVEBOOL = userDefaults.bool(forKey: AUTOSAVE)
        super.viewWillDisappear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.AUTOSAVEBOOL = userDefaults.bool(forKey: AUTOSAVE)
        super.viewDidAppear(animated)
    }
  
    
   
    
    func setupRateApp() {
        let launchCount = UserDefaults.standard.integer(forKey: "setupRateApp")
        if launchCount <= 1 {
            
           // SwiftyRate.Request(from: self, afterAppLaunches: 5)
            //KHALED
            let ratingsRequest = SwiftyRate.Request(
                afterAppLaunches: 5,
                customAlertTitle: "Enjoying this app",
                customAlertMessage: "Tap the stars to rate it on the App Store.",
                customAlertActionCancel: "Not Now"
            )
            SwiftyRate.requestReview(ratingsRequest, from: self)
            UserDefaults.standard.set((launchCount + 1), forKey: "setupRateApp")
            print("launchCount " , launchCount)
        }
    }

    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

//    @IBAction func btnStartDownload(_ sender: Any) {
//
//
//        let url = UIPasteboard.general.string
//
//        if !self.validatUrl(urlString: url) {
//            self.messageWrong("الرابط المدخل غير صحيح !")
//            self.reset()
//            return
//        }
//
//
//
//        getUrl(url ?? "")
//
//       reset()
//
//
//
//    }
    struct VideoData:Codable{
        var id : String
        var label : String
    }
    struct ResponsData:Codable{
        var title : String
        var urls : [VideoData]
    }
    func getUrl(_ urlString:String) {
//        downloadManager
        if self.downloadButton.state == .pending{
//            self.btnStartDownload.stopLoading()
            downloadManager.pauseDownloadTaskAtIndex(downloadManager.downloadingArray.count - 1)
            return
        }
        if !fileURL.isEmpty{
            downloadManager.resumeDownloadTaskAtIndex(downloadManager.downloadingArray.count - 1)
//            self.btnStartDownload.startLoading()
            return
        }
        if urlString.lowercased().contains("twitter") || urlString.lowercased().contains("facebook") || urlString.lowercased().contains("instagram") || urlString.lowercased().contains("youtube") ||  urlString.lowercased().contains("youtu") ||  urlString.lowercased().contains("tiktok") ||  urlString.lowercased().contains("x"){
            let url = "https://kortna.co/wp-json/aio-dl/api/"
            
            print("\(url)\(urlString)")
            
            AF.sessionConfiguration.timeoutIntervalForRequest = 12000000
            downloadButton.state = .pending

            AF.request(url, method: .get, parameters: ["url":urlString]).responseDecodable(of: ResponsData.self) {(data) in
                if let e = data.error {
                    print("Error " , e.localizedDescription)
                    self.messageWrong("لا يمكن جلب الملف من الموقع نأمل المحاولة في وقتٍ لاحق ")
                    return
                }
                print(try! data.result.get())
                switch data.result {
                case .success(let value):
//                    do{
                            print(value.urls.first?.id ?? "Nothing")
                            let urlVideo = value.urls.first?.id ?? "Nothing"
                            let urlSstring = urlVideo .replacingOccurrences(of: "//", with: "/").replacingOccurrences(of: ":/", with: "://")
                            let nameString = (value.urls.first?.label) ?? "aaa.mp4"
                            print(urlSstring)
                            self.fileURL = urlVideo
                            let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(nameString ) as NSString)
                            downloadManager.addDownloadTask(fileName as String, fileURL: self.fileURL , destinationPath: myDownloadPath)
                            downloadManager.delegate = self
                            self.downloadButton.state = .downloading
                            GoogleAdsObject.share.showInterstitial(viewController: self)
                        
//                    }catch{
//                        self.downloadButton.state = .startDownload
//                        self.messageWrong("لا يمكن جلب الملف من الموقع نأمل المحاولة في وقتٍ لاحق ")
//                        print(error.localizedDescription)
//                    }
                case .failure(let error):
                    self.downloadButton.state = .startDownload
                    self.messageWrong("لا يمكن جلب الملف من الموقع نأمل المحاولة في وقتٍ لاحق ")
                    print(error)
                }
                
            }
        }else{
            let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(urlString) as NSString)
            downloadManager.addDownloadTask(fileName as String, fileURL: fileURL , destinationPath: myDownloadPath)
            downloadManager.delegate = self
            GoogleAdsObject.share.showInterstitial(viewController: self)

        }
        }
    
    @IBAction func btnVCSetting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "YESettingsViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnVCDownloaded(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MZDownloadedViewController")
        vc?.modalPresentationStyle = .formSheet
        self.present(vc!, animated: true)
//        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    func dComplate(_ num: Double) {
        print("num " , num)
//        self.progressView.maxValue = 100
//        self.progressView.value = CGFloat(num)
    }
    
    
    func counter(_ totalBytesWritten: Float, totalUnitCount: Float) {
        let p = (totalBytesWritten / totalUnitCount)
        let f = Int(p*100)
//        progressLbl.text = "%\(f)"
        //KHALED
       // progressView.value = UICircularProgressRing.ProgressValue(f)
       // progressView.setProgress(p, animted: true)
    }
    
    func cancel() {
        self.reset()
    }
    
    func dIsSuccess(_ state: Bool) {
        print("state " , state)
        if state {
            self.msgDone("تم حفظ الفيديو بالاستديو بنجاح ")
            
            DispatchQueue.main.async {
                self.reset()
            }
        }
    }
    
    func error() {
        self.reset()
        self.messageWrong("لا يمكن جلب الفيديو من الموقع نأمل المحاولة في وقتٍ لاحق ")
    }
    
    func msgAuthWrong() {
        self.reset()
        self.messageWrong("إن سياسة الموقع المراد تحميل الفيديو منه لا تسمح بذالك نأمل إختيار المواقع التي تسمح بالتحميل وشكراً ")
    }
    
    
//    func setGradientBackground() {
//        let colorTop =  UIColor.black.withAlphaComponent(0.8).cgColor
//        let colorCenter =  UIColor.black.withAlphaComponent(0.5).cgColor
//        let colorBottom = UIColor.black.withAlphaComponent(0.8).cgColor
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorTop,colorCenter, colorBottom]
//        gradientLayer.locations = [0.0,0.5,1.0]
//        gradientLayer.cornerRadius = 65
//        gradientLayer.borderColor = UIColor.white.cgColor
//        gradientLayer.borderWidth = 3
//        gradientLayer.frame = self.btnStartDownload.bounds
//        btnStartDownload.layer.insertSublayer(gradientLayer, at: 0)
//    }
//    func removeGradientBackground() {
////        btnStartDownload.remove
////        btnStartDownload.layer.isHidden = true
//    }
}

extension MainViewController {
    
    
    func msgDone(_ msg : String) {
        
        DispatchQueue.main.async {
            let popup = PopupDialog(title: "✅", message: msg)

            let cancel = CancelButton(title: "موافق") {
                
            }
            
            popup.addButton(cancel)

            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    func messageRight(_ msg : String) {
        
        DispatchQueue.main.async {
//            let popup = PopupDialog(title: "✅", message: msg)
//
//            let cancel = CancelButton(title: "موافق") {}
//
//            popup.addButton(cancel)
//
//            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    func messageWrong(_ msg : String) {
        
        DispatchQueue.main.async {
            let popup = PopupDialog(title: "❌", message: msg)

            let cancel = CancelButton(title: "موافق") {}

            popup.addButton(cancel)

            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    func reset() {
        //KHALED
        
//        clsGoogleAds.share.loadGoogleAds(in: self)
//        self.btnStartDownload.setTitle("تحميل", for: .normal)
//        clsDownlosd.share.downloadIsStart = false
//        self.textFieldUrl.text? = ""
//        self.progressView.value = 0
       
      //  progressView.value = UICircularProgressRing.ProgressValue(0)
//        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
//            self.ProgressViewContainerView.alpha = 0
//        }, completion: nil)
//
        
//        clsDownlosd.share.downloadIsStart = false
    }
    
    //    Validat url
    func validatUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = URL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension MainViewController: AHDownloadButtonDelegate {
    func downloadButton(_ downloadButton: AHDownloadButton, tappedWithState state: AHDownloadButton.State) {
//        switch state {
//            case .startDownload:
//            let url = UIPasteboard.general.string
//
//            if !self.validatUrl(urlString: url) {
//                self.messageWrong("الرابط المدخل غير صحيح !")
//                self.reset()
//                return
//            }
//
//
//
//            getUrl(url ?? "")
//
//           reset()
//
//        default:
//            break
//        }
    }
}
