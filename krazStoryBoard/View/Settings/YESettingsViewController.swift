//
//  YESettingsViewController.swift
//  AppStatusWhatsApp
//
//  Created by Yahaya Ahmed on 2/16/18.
//  Copyright © 2018 Yahaya. All rights reserved.
//

import UIKit

import UserNotifications

let ApplicationIsActive = "ApplicationIsActive"

class YESettingsViewController: UITableViewController {
    @IBOutlet var control:UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        let settings = UIApplication.shared.currentUserNotificationSettings
//
//        if (settings?.types.contains(.alert))! {
//            control.setOn(true, animated: true)
//        }else{
//            control.setOn(false, animated: true)
//        }
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
    @IBAction func goToWhatApp(_ sender:Any){
        let phoneNumber =  "+970567794205" // you need to change this number
        let appURL = URL(string: "https://wa.me/\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
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

