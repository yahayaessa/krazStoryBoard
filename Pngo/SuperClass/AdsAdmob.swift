//
//  AdsAdmob.swift
//  alzeeb
//
//  Created by hassan duhair on 2/14/19.
//  Copyright © 2019 abd. All rights reserved.
//

import Foundation
import GoogleMobileAds


protocol adMobDelegate {
    func runAdsBaneer()
}


class clsGoogleAds: NSObject , GADFullScreenContentDelegate {
    
    var delegate: adMobDelegate?
    static var share = clsGoogleAds()
    
    override init() { }
    
    //admob Ads  native
    var adLoader: GADAdLoader!
    
    var interstitial: GADInterstitialAd!
    var timer = Timer()
    var vc: UIViewController!
    
    func createAd(completion: @escaping (GADInterstitialAd)->Void)  {
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3233536447139983/5597366256",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
            completion(interstitial)
        })
        
    }
    
    
    //ca-app-pub-3233536447139983~3286310954 -pngo
    //ca-app-pub-3233536447139983/5597366256 -after download video
    //ca-app-pub-3233536447139983/6814492427 -old
    //ca-app-pub-3233536447139983/4254623948 -new
    
    //ca-app-pub-3233536447139983~3576020999 -pngo
    //ca-app-pub-3233536447139983/2937726742 --new
    
    //ca-app-pub-3233536447139983/6130812391 -pngo after run app
    
    //    func showAd() {
    //        if interstitialView != nil {
    //            if (interstitialView.isReady == true){
    //                interstitialView.present(fromRootViewController:currentVc)
    //            } else {
    //                print("ad wasn't ready")
    //                interstitialView = createAd()
    //            }
    //        } else {
    //            print("ad wasn't ready")
    //            interstitialView = createAd()
    //        }
    //    }
    
    
    @objc func showGoogleAds(viewController:UIViewController) {
        //KHALED
        vc = viewController
      //  if interstitial.isReady {
        //    interstitial.present(fromRootViewController: viewController)
          //  loadGoogleAds()
       // }
       
            print("Ad wasn't ready")
            createAd(completion: { ad in
                self.interstitial = ad
            })
            //loadGoogleAds()
            //showGoogleAds(viewController: viewController)
    
    }
    
    func startTimerForShowAds() {
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(showGoogleAds), userInfo: nil, repeats: true)
    }
    
    func loadGoogleAds() {
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3233536447139983/5597366256",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
        
        
    }
    
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitialAd) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitialAd, didFailToReceiveAdWithError error: Error) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitialAd) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitialAd) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitialAd) {
        print("interstitialDidDismissScreen")
        loadGoogleAds()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitialAd) {
        print("interstitialWillLeaveApplication")
    }
}




extension clsGoogleAds : GADBannerViewDelegate{
    
    // add banner ads
    func setupBannerAds(bannerView:GADBannerView , viewController:UIViewController , adUnitID:String) {
        bannerView.delegate = self
        bannerView.adUnitID = adUnitID
        let request = GADRequest()
        bannerView.rootViewController = viewController
        bannerView.load(request)
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd banner")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: Error) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}


