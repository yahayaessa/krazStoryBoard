//
//  ViewController.swift
//  Hero
//
//  Created by fadel sultan on 8/19/18.
//  Copyright © 2018 fadel sultan. All rights reserved.
//

import UIKit
import PopupDialog
//import UICircularProgressRing
import Foundation
import GoogleMobileAds
import SwiftyRate
import Alamofire
import AVFAudio
import AVFoundation
import AVKit
//import MZDownloadManager

class MainViewController: NativeAdsVC, MZDownloadManagerDelegate  {
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [MZDownloadModel]) {
        
    }
    
    
    @IBOutlet weak var adView: UIView!

    
    @IBOutlet weak var viewBanner: GADBannerView!

//    @IBOutlet weak var ProgressViewContainerView: UIViewX!
    @IBOutlet weak var textFieldUrl: UITextField!
    @IBOutlet weak var btnStartDownload: UIButton!
    
    @IBOutlet weak var progressLbl: UILabel!
//    @IBOutlet weak var progressView: UICircularProgressRing!

    var downloadedFilesArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        downloadManager.delegate = self
        setupRateApp()
        self.setupAd()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    
    override func setupAd() {
        self.nativeAdPlaceholder = adView
        super.setupAd()
        GoogleAdsObject.share.loadGoogleAdsInterstitial()
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

    
    func downloadProgressUpdate(for progress: Float) {
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func pasteText(_ sender: Any) {
        let content = UIPasteboard.general.string
        textFieldUrl.text = content
    }
    @IBAction func clearText(_ sender: Any) {
        textFieldUrl.text = ""
    }
    @IBAction func btnStartDownload(_ sender: Any) {
        
        self.view.endEditing(true)
        if (self.textFieldUrl.text?.isEmpty)! {
            self.messageWrong("لم يتم إدخال الرابط \n يجب كتابة الرابط اولاً ")
            return
        }

        if !self.validatUrl(urlString: self.textFieldUrl.text) {
            self.messageWrong("الرابط المدخل غير صحيح !")
            self.reset()
            return
        }
        let url = self.textFieldUrl.text!
        getUrl(url)

       reset()
       
        //        if !clsDownlosd.share.downloadIsStart{
//
//            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
//                self.ProgressViewContainerView.alpha = 1
//            }, completion: nil)
//
//            clsDownlosd.share.downloadIsStart = true
//            var mmm = textFieldUrl.text ?? ""
//            if(mmm.last == "/") {
//                mmm.removeLast()
//
//            }
//            clsDownlosd.share.checkUrl(mmm.trimmingCharacters(in: .whitespacesAndNewlines))
//
//        }


    }
    
    func getUrl(_ urlString:String) {
        
        
        
        if urlString.lowercased().contains("twitter") || urlString.lowercased().contains("facebook") || urlString.lowercased().contains("instagram") || urlString.lowercased().contains("youtube") ||  urlString.lowercased().contains("youtu") ||  urlString.lowercased().contains("tiktok"){
            let url = "http://haniapp.me/wordpress/wp-json/aio-dl/api/"
            
            print("\(url)\(urlString)")
            
            IJProgressView.shared.showProgressView()
            AF.request(url, method: .get, parameters: ["url":urlString]).responseJSON {(data) in
                if let e = data.error {
                    print("Error " , e.localizedDescription)
                    IJProgressView.shared.hideProgressView()
                    self.messageWrong("لا يمكن جلب الملف من الموقع نأمل المحاولة في وقتٍ لاحق ")
                    return
                }
                
                switch data.result {
                case .success(let value):
                    if let json = value as? [String:Any]{
                        print(json.keys)
                        if json["error"] == nil{
                            print("id video " , (((value as AnyObject).object(forKey: "urls") as! NSArray)[0] as AnyObject).object(forKey: "id") ?? "Nothing")
                            
                            let urlVideo = (((value as AnyObject).object(forKey: "urls") as! NSArray)[0] as AnyObject).object(forKey: "id") ?? "Nothing"
                            print(urlVideo)
                            let urlSstring = (urlVideo as! String).replacingOccurrences(of: "//", with: "/").replacingOccurrences(of: ":/", with: "://")
                            let nameString = (((value as AnyObject).object(forKey: "urls") as! NSArray)[0] as AnyObject).object(forKey: "label") ?? "Nothing"
                            IJProgressView.shared.hideProgressView()
//                            if self.downloadedFilesArray.contains(nameString as! String){
//                                self.messageWrong("تم بالفعل تحميل الملف")
//                                return
//                            }
                            print(urlSstring)
                            let download = self.storyboard!.instantiateViewController(withIdentifier: "MZDownloadManagerViewController") as? MZDownloadManagerViewController
                            let fileURL   = urlVideo as! String

//                            if urlString.lowercased().contains("youtube") ||  urlString.lowercased().contains("youtu"){
//                                 fileURL   = urlSstring
//                            }
                            let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(nameString as! String) as NSString)

                            downloadManager.addDownloadTask(fileName as String, fileURL: fileURL , destinationPath: myDownloadPath)
                            self.navigationController?.pushViewController(download!, animated: true)
                            GoogleAdsObject.share.showInterstitial(viewController: self)
                        }else{
                            IJProgressView.shared.hideProgressView()
                            self.messageWrong("لا يمكن جلب الملف من الموقع نأمل المحاولة في وقتٍ لاحق ")
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }else{
            let download = self.storyboard!.instantiateViewController(withIdentifier: "MZDownloadManagerViewController") as? MZDownloadManagerViewController
            let fileURL  : NSString = urlString as NSString
            let nameString  = fileURL.lastPathComponent
            downloadManager.addDownloadTask(nameString, fileURL: fileURL as String, destinationPath: myDownloadPath)
            self.present(download!, animated: true)
        }
        }
    
    @IBAction func btnVCSetting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "YESettingsViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnVCDownloaded(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MZDownloadedViewController")
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    func dComplate(_ num: Double) {
        print("num " , num)
//        self.progressView.maxValue = 100
//        self.progressView.value = CGFloat(num)
    }
    
    
    func counter(_ totalBytesWritten: Float, totalUnitCount: Float) {
        let p = (totalBytesWritten / totalUnitCount)
        let f = Int(p*100)
        progressLbl.text = "%\(f)"
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
        self.textFieldUrl.text? = ""
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

