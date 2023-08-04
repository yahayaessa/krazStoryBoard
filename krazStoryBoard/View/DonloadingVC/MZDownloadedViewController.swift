//
//  MZDownloadedViewController.swift
//  MZDownloadManager
//
//  Created by Muhammad Zeeshan on 23/10/2014.
//  Copyright (c) 2014 ideamakerz. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class MZDownloadedViewController: UITableViewController {
    
    var downloadedFilesArray : [String] = []
    var selectedIndexPath    : IndexPath?
    var fileManger           : FileManager = FileManager.default
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)

            addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-4338073629880099/8271075058"
          bannerView.rootViewController = self
        bannerView.load(GADRequest())
        // Do any additional setup after loading the view.
        do {
            let contentOfDir: [String] = try FileManager.default.contentsOfDirectory(atPath: myDownloadPath)
            downloadedFilesArray.append(contentsOf: contentOfDir)
            
            let index = downloadedFilesArray.firstIndex(of: ".DS_Store")
            if let index = index {
                downloadedFilesArray.remove(at: index)
            }
            
        } catch let error as NSError {
            print("Error while getting directory content \(error)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(downloadFinishedNotification(_:)), name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif as String), object: nil)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NSNotification Methods -
    
    @objc func downloadFinishedNotification(_ notification : Notification) {
        let fileName : NSString = notification.object as! NSString
        downloadedFilesArray.append(fileName.lastPathComponent)
        tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
    }
}

//MARK: UITableViewDataSource Handler Extension

extension MZDownloadedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedFilesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier : NSString = "DownloadedFileCell"
        let cell : DownloadedFileCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! DownloadedFileCell
//        if #available(iOS 16.0, *) {
//            cell.videoUrl = URL(filePath: self.downloadedFilesArray[indexPath.row])
//        } else {
        cell.videoUrl = URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent( self.downloadedFilesArray[indexPath.row] as String))

            // Fallback on earlier versions
//        }
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(shareVideo), for: UIControl.Event.touchUpInside)
        cell.titleLabel.text = downloadedFilesArray[(indexPath as NSIndexPath).row]
        cell.getAllFrames()

        return cell
    }
    @objc func shareVideo(_ sender:UIButton){
        let videoLink  : URL = URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent( self.downloadedFilesArray[sender.tag] as String))

        let objectsToShare = [videoLink] //comment!, imageData!, myWebsite!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.setValue("Video", forKey: "subject")


        // New Excluded Activities Code
        if #available(iOS 9.0, *) {
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail, UIActivity.ActivityType.message, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToTencentWeibo, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.print]
        } else {
            // Fallback on earlier versions
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail, UIActivity.ActivityType.message, UIActivity.ActivityType.postToTencentWeibo, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.print ]
        }

                   
        self.present(activityVC, animated: true, completion: nil)
    }
}

//MARK: UITableViewDelegate Handler Extension

extension MZDownloadedViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        
        let player = storyboard?.instantiateViewController(withIdentifier: "ASPPlayerViewController") as! PlayerViewController
        let fileName : NSString = downloadedFilesArray[(indexPath as NSIndexPath).row] as NSString
        let fileURL  : URL = URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent(fileName as String))
        player.firstLocalVideoURL = fileURL
        self.navigationController?.pushViewController(player, animated: true)
//        self.present(player, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fileName : NSString = downloadedFilesArray[(indexPath as NSIndexPath).row] as NSString
        let fileURL  : URL = URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent(fileName as String))
        
        do {
            try fileManger.removeItem(at: fileURL)
            downloadedFilesArray.remove(at: (indexPath as NSIndexPath).row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        } catch let error as NSError {
            debugPrint("Error while deleting file: \(error)")
        }
    }
}
class DownloadedFileCell:UITableViewCell{
    @IBOutlet var shareButton:UIButton!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var photoImageView:UIImageView!

    var videoUrl:URL! // use your own url
    var frames:[UIImage] = []
    private var generator:AVAssetImageGenerator!

    
    func getAllFrames() {
       let asset:AVURLAsset = AVURLAsset(url: self.videoUrl)
       self.generator = AVAssetImageGenerator(asset: asset)
       self.generator.appliesPreferredTrackTransform = true
        photoImageView.image = self.getFrame(fromTime:Float64(10))
       self.generator = nil
    }
    private func getFrame(fromTime:Float64) ->UIImage{
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:600)
        let image:CGImage
        do {
           try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch {
            print(error.localizedDescription)
           return UIImage()
        }
        return UIImage(cgImage:image)
    }
}
