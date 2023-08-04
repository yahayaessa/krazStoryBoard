

import Foundation
import GoogleMobileAds

protocol GAdsDelegate {
    func runAdsBaneer()
}

class GoogleAdsObject: NSObject , GADFullScreenContentDelegate{
    
    var delegate:GAdsDelegate?
    
    static var share = GoogleAdsObject()
    
    override init() {
        
    }
    
    //admob Ads  native
    var adLoader: GADAdLoader!
    
    var viewAdsNative:UIView!
    
    var nativeAdView: GADNativeAdView!
    
    var interstitial: GADInterstitialAd?
    
    
    
    var timer = Timer()
    var vc: UIViewController!
    
    func loadGoogleAdsInterstitial(){
        let request = GADRequest()
           GADInterstitialAd.load(withAdUnitID:"ca-app-pub-4338073629880099/2812495123",
                                       request: request,
                             completionHandler: { [self] ad, error in
                               if let error = error {
                                 print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                 return
                               }
                               interstitial = ad
                             }
      )
    }
    func showInterstitial(viewController:UIViewController){
        if interstitial != nil {
            interstitial!.present(fromRootViewController: viewController)
          } else {
            print("Ad wasn't ready")
          }
    }
    @objc func showGoogleAds(viewController:UIViewController) {
        
        vc = viewController

        //KHALED
      //  if interstitial.isReady {
//            interstitial.present(fromRootViewController: viewController)
            loadGoogleAds(in: viewController)
//        } else {
//            print("Ad wasn't ready")
//            interstitial = createAd()
//        }
//
    }
    
    func startTimerForShowAds() {
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(showGoogleAds), userInfo: nil, repeats: true)
    }

    
    func loadGoogleAds(in viewConttroller: UIViewController) {
        //KHALED
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3233536447139983/2760399673",
            rootViewController: viewConttroller,
            adTypes: [ .native ],
            options: [])
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
        
        
//
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3233536447139983/2760399673")
//        interstitial.delegate = self
//        let request = GADRequest()

//
//        interstitial.delegate = self
//        interstitial.load(request)

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
        loadGoogleAds(in: vc)
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitialAd) {
        print("interstitialWillLeaveApplication")
    }
}


extension GoogleAdsObject : GADBannerViewDelegate{
    
    // add banner ads
    func setupBannerAds(bannerView:GADBannerView , viewController:UIViewController , adUnitID:String) {
        bannerView.delegate = self
        
        bannerView.adUnitID = adUnitID
        let request = GADRequest()
//        request.testDevices = ["07f1fce20a9874f9018fffd952200bbb" , kGADSimulatorID]
        bannerView.rootViewController = viewController
        bannerView.load(request)
        
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd banner")
    }
    
    /// Tells the delegate an ad request failed.
    func bannerView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: Error) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
}


extension GoogleAdsObject : GADAdLoaderDelegate , GADNativeAdLoaderDelegate , GADNativeAdDelegate  {
    
    func setupAdsNativView(viewController:UIViewController , adUnitID:String) {
        self.viewAdsNative.isHidden = true
        
        
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: viewController, adTypes: [.native], options: nil)
        
        adLoader.delegate = self
        let request = GADRequest()
//        request.testDevices = ["07f1fce20a9874f9018fffd952200bbb" , kGADSimulatorID]
        adLoader.load(request)
        
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("adLoaderDidFinishLoading")
        self.viewAdsNative.isHidden = false
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        delegate?.runAdsBaneer()
        print("Error is " , error.localizedDescription)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
        self.nativeAdView = Bundle.main.loadNibNamed("AdsNativeApp", owner: nil, options: nil)?.first as? GADNativeAdView
        self.viewAdsNative.addSubview(self.nativeAdView)
        
        // TODO: Make sure to add the GADNativeAppInstallAdView to the view hierarchy.
        print("Load ads native")
        // Associate the app install ad view with the app install ad object. This is
        // required to make the ad clickable as well as populate the media view.
        self.nativeAdView.nativeAd = nativeAd
        nativeAd.delegate = self
        
        (self.nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (self.nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        (self.nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
    }


    
}

