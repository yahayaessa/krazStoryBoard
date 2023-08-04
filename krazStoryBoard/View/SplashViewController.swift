//
//  SplashViewController.swift
//  krazStoryBoard
//
//  Created by AnAs on 16/10/2022.
//

import UIKit
import Firebase
class SplashViewController: UIViewController {
    var remoteConfig: RemoteConfig!
    let isOnlineConfigKey = "isOnline"

    override func viewDidLoad() {
        super.viewDidLoad()
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 2
        remoteConfig.configSettings = settings
        fetchConfig()
        // Do any additional setup after loading the view.
    }
    
    func fetchConfig() {
       

       // [START fetch_config_with_callback]
       remoteConfig.fetch { (status, error) -> Void in
         if status == .success {
           print("Config fetched!")
             DispatchQueue.main.async {
                 if self.remoteConfig[self.isOnlineConfigKey].boolValue{
                     self.gotoUnPressVideo()
                 }else{
                     self.gotoPressVideo()
                 }
                 
             }
             
           self.remoteConfig.activate { changed, error in
               
               DispatchQueue.main.async {
                   if self.remoteConfig[self.isOnlineConfigKey].boolValue{
                       self.gotoUnPressVideo()
                   }else{
                       self.gotoPressVideo()
                   }
                   
               }
           }
         } else {
           print("Config not fetched")
           print("Error: \(error?.localizedDescription ?? "No error available.")")
         }
       }
       // [END fetch_config_with_callback]
     }
    func gotoUnPressVideo() {
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            appDelegate?.gotoUnPressVideo()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.gotoUnPressVideo()
            // Fallback on earlier versions
        }
        
    }
    func gotoPressVideo() {
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            appDelegate?.gotoPressVideo()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.gotoPressVideo()
            // Fallback on earlier versions
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
