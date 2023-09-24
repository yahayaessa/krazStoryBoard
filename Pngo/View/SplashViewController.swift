//
//  SplashViewController.swift
//  krazStoryBoard
//
//  Created by AnAs on 16/10/2022.
//

import UIKit
import Firebase
class SplashViewController: UIViewController {
//
//    var remoteConfig: RemoteConfig!
//    let isOnlineConfigKey = "isOnline"
    var urlComparssHD1080 = ""
    var urlComparssHD720 = ""
    var urlComparss420 = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        remoteConfig = RemoteConfig.remoteConfig()
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 2
//        remoteConfig.configSettings = settings
//        fetchConfig()
        // Do any additional setup after loading the view.
        authDownload { isAuth in
            if isAuth{
                self.gotoUnPressVideo()
            }else{
                self.gotoPressVideo()
            }
        }
    }
    
    func fetchConfig() {
       

       // [START fetch_config_with_callback]
//       remoteConfig.fetch { (status, error) -> Void in
//         if status == .success {
//           print("Config fetched!")
//             DispatchQueue.main.async {
//                 if self.remoteConfig[self.isOnlineConfigKey].boolValue{
//                     self.gotoUnPressVideo()
//                 }else{
//                     self.gotoPressVideo()
//                 }
//
//             }
//
//           self.remoteConfig.activate { changed, error in
//
//               DispatchQueue.main.async {
//                   if self.remoteConfig[self.isOnlineConfigKey].boolValue{
//                       self.gotoUnPressVideo()
//                   }else{
//                       self.gotoPressVideo()
//                   }
//
//               }
//           }
//         } else {
//           print("Config not fetched")
//           print("Error: \(error?.localizedDescription ?? "No error available.")")
//         }
//       }
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
    
    func authDownload(result : @escaping (_ value:Bool)->()) {
        var db: Firestore!
        db = Firestore.firestore()
        
        let docRef = db.collection("authDownload").document("70uDAkjkNsKqpk1K5vG8")
        docRef.getDocument { (document, error) in
            
            if let dict = document?.data() {
                self.urlComparssHD1080 = dict["urlComparssHD1080"] as! String
                self.urlComparssHD720 = dict["urlComparssHD720"] as! String
                self.urlComparss420 = dict["urlComparss420"] as! String
                print(self.urlComparss420)
                print(self.urlComparssHD720)
                print(self.urlComparssHD1080)
                result((dict["IsAuthDownload"] as? Bool)!)
            }
            
            if error != nil {
                result(false)
                print("error " , error!.localizedDescription)
            }
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
