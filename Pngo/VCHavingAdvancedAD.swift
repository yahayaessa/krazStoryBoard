//
//  VCHavingAdvancedAD.swift
//  alzeeb
//
//  Created by Khaled Macbook on 02/04/2022.
//  Copyright © 2022 abd. All rights reserved.
//

import UIKit
import GoogleMobileAds

class VCHavingAdvancedAD: UIViewController, GADVideoControllerDelegate {
    
    var nativeAdPlaceholder: UIView!
    var adLoader: GADAdLoader!
    var nativeAdView: GADNativeAdView!
    let adUnitID = "ca-app-pub-3233536447139983/4254623948"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAd()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setLayout()
    }
    
    func setupAd(){
        nativeAdPlaceholder = UIView()
        self.view.addSubview(nativeAdPlaceholder)
        
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
    
    
    func setLayout(){
        nativeAdPlaceholder.setConstraints(bottom: self.view.bottomAnchor, paddingBottom: 0,
                                           leading: self.view.leadingAnchor,
                                           trialaing: self.view.trailingAnchor,
                                           heightAnchor: self.view.heightAnchor, heightMultiplier: 0.22)
        nativeAdView.setConstraints(equalToConstraintsOf: nativeAdPlaceholder)
    }
    
}




extension VCHavingAdvancedAD: GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        for _ in 0...99{
            print("Error\(error.localizedDescription)")
        }
    }
    
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
  
        for _ in 0...99{
            print("KHALED")
        }
       

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

       // (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        //nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

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

