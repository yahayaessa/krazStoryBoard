//
//  NativeAdsVC.swift
//  krazStoryBoard
//
//  Created by AnAs on 11/10/2022.
//

import UIKit
import GoogleMobileAds
class NativeAdsVC: UIViewController, GADVideoControllerDelegate {
    
    var nativeAdPlaceholder: UIView!
    var adLoader: GADAdLoader!
    var nativeAdView: GADNativeAdView!
    let adUnitID = "ca-app-pub-4338073629880099/8309134896"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutAd()
    }
    
    func setupAd(){
        
        guard
          let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil),
          let adView     = nibObjects.first as? GADNativeAdView
        else {
          assert(false, "Could not load nib file for adView")
            return
        }
        
        nativeAdView = adView
        nativeAdPlaceholder.addSubview(nativeAdView)
        
        adLoader = GADAdLoader(
        adUnitID: adUnitID,
        rootViewController: self,
        adTypes: [.native],
        options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    
    }
    
    
    func layoutAd(){
        nativeAdView.setConstraints(equalToConstraintsOf: nativeAdPlaceholder)
    }
    
}




extension NativeAdsVC: GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
//        for _ in 0...99{
            print("Error\(error.localizedDescription)")
//        }
    }
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
          return nil
        }
        if rating >= 5 {
          return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
          return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
          return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
          return UIImage(named: "stars_3_5")
        } else {
          return nil
        }
      }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
  
       

        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self

        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
      
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
          
        // Some native ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
        // UI accordingly.
        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
          // By acting as the delegate to the GADVideoController, this ViewController receives messages
          // about events in the video lifecycle.
          mediaContent.videoController.delegate = self
        }

        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
       

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd

    }


    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
      print("\(#function) called")
    }

    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
      print("\(#function) called")
    }

    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
      print("\(#function) called")
    }

    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
      print("\(#function) called")
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
      print("\(#function) called")
    }

    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
      print("\(#function) called")
    }
  }


