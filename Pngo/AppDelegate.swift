//
//  AppDelegate.swift
//  krazStoryBoard
//
//  Created by AnAs on 09/10/2022.
//

import UIKit
import GoogleMobileAds
import Firebase
import AppTrackingTransparency
let myDownloadPath = MZUtility.baseFilePath + "/My Downloads"
var downloadManager: MZDownloadManager = {
    
    let sessionIdentifer: String = "com.iosDevelopment.MZDownloadManager.BackgroundSession"
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: nil, completion: completion)
        return downloadmanager
    }()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler : (() -> Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "487abab4b1c1caea57bb0599c6d78b60",GADSimulatorID ]
        requestIDFA()
        return true
    }
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
            })
        } else {
            // Fallback on earlier versions
        }
    }
    func gotoUnPressVideo() {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let signInPage = SB.instantiateViewController(withIdentifier: "ChosingServiceVC") as! ChosingServiceVC
        self.window?.rootViewController = signInPage
        self.window?.makeKeyAndVisible()
    }
    func gotoPressVideo() {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let signInPage = SB.instantiateViewController(withIdentifier: "NVcomparessVideo") as! UINavigationController
        self.window?.rootViewController = signInPage
        self.window?.makeKeyAndVisible()
    }
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
}

