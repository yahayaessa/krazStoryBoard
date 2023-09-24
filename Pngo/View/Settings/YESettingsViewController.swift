//
//  YESettingsViewController.swift
//  AppStatusWhatsApp
//
//  Created by Yahaya Ahmed on 2/16/18.
//  Copyright © 2018 Yahaya. All rights reserved.
//

import UIKit
import StoreKit

import UserNotifications

let ApplicationIsActive = "ApplicationIsActive"

class YESettingsViewController: UITableViewController {
    @IBOutlet var control:UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        control.setOn(userDefaults.bool(forKey: AUTOSAVE), animated: false)

        NotificationCenter.default.addObserver(self, selector: #selector(YESettingsViewController.updateNotificationSwitch), name: Notification.Name(rawValue: ApplicationIsActive), object: nil)
    }
    
    
    @objc func updateNotificationSwitch(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
          if settings.authorizationStatus == .authorized {
            // Notifications are allowed
              self.control.setOn(true, animated: true)
          }
          else {
              self.control.setOn(false, animated: true)
            // Either denied or notDetermined
          }
        }
    }
    @IBAction func AutoSaveAction(sender: UISwitch){
        userDefaults.set(sender.isOn, forKey: AUTOSAVE)
        userDefaults.synchronize()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    fileprivate func prepareSwitch(cell:UITableViewCell) {
//        let settings = UIApplication.shared.currentUserNotificationSettings
//        if (settings?.types.contains(.alert))! {
//            control.setOn(true, animated: true)
//        }else{
//            control.setOn(false, animated: true)
//        }
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell")
//            self.updateNotificationSwitch()
//            return cell!
//        }else if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "numberMessageCell")
//            return cell!
//        }else if indexPath.row == 2{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "numberAppCell")
//            return cell!
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "WhatsAppCell")
//            return cell!
//        }
//    }
    
    @IBAction func purchaseAction(_ sender:Any){
//        IJProgressView().showProgressView()
        Purchases.default.initialize { product in
//            DispatchQueue.main.async {
//                IJProgressView().hideProgressView()
//            }
            Purchases.default.purchaseProduct(productId: "RemoveAdMonth") {
                [weak self] _ in
                
                // Handle result
            }
        }
           
    }
    @IBAction func btnTwitter(_ sender: Any) {
        let url = URL(string: "https://twitter.com/iphoneexx")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
