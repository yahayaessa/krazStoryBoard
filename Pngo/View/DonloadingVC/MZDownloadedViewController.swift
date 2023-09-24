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
import iOSDropDown
import PopMenu
import Photos
import AlertKit
enum TypeCell{
    case ad
    case file
}
struct DataFile{
    var type:TypeCell
    var path:String

}
class MZDownloadedViewController: UIViewController {
    var downloadedFiles : [DataFile] = []
    
    var downloadedFilesArray : [String] = []
    var selectedIndexPath    : IndexPath?
    var fileManger           : FileManager = FileManager.default
    var bannerView: GADBannerView!
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        bannerView = GADBannerView(adSize: GADAdSizeBanner)
//
//        addBannerViewToView(bannerView)
//        bannerView.adUnitID = "ca-app-pub-4338073629880099/8271075058"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        // Do any additional setup after loading the view.
        do {
            let contentOfDir: [String] = try FileManager.default.contentsOfDirectory(atPath: myDownloadPath)
            
            downloadedFilesArray.append(contentsOf: contentOfDir)
            
            let index = downloadedFilesArray.firstIndex(of: ".DS_Store")
            if let index = index {
                downloadedFilesArray.remove(at: index)
            }
            reloadFileArray()
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
    func reloadFileArray(){
        downloadedFiles = []
        for index in 0..<downloadedFilesArray.count {
            if index % 4 == 0{
                downloadedFiles.append(DataFile(type: .ad, path: ""))
            }
            downloadedFiles.append(DataFile(type: .file, path: downloadedFilesArray[index]))
        }
        self.tableView.reloadData()
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
        downloadedFiles.append(DataFile(type: .file, path: fileName.lastPathComponent))
        tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
    }
}

//MARK: UITableViewDataSource Handler Extension

extension MZDownloadedViewController :UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedFiles.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier : NSString = "DownloadedFileCell"
         let cellIMZAdCelldentifier : NSString = "MZAdCell"

         if  self.downloadedFiles[indexPath.row].type == .ad{
             let cell : MZAdCell = self.tableView.dequeueReusableCell(withIdentifier: cellIMZAdCelldentifier as String, for: indexPath) as! MZAdCell
             cell.rootViewController = self
             return cell
         }else{
             let cell : DownloadedFileCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! DownloadedFileCell

              cell.videoUrl = URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent( self.downloadedFiles[indexPath.row].path as String))
             cell.rootViewController = self
              cell.tableview = tableView
              cell.indexPath = indexPath
             cell.shareButton.tag = indexPath.row
             cell.deleteVideo = {
                 do{
                     try FileManager.default.removeItem(at: cell.videoUrl)
                     self.downloadedFilesArray.remove(at: indexPath.row)
                     self.downloadedFiles.remove(at: indexPath.row)
                     self.reloadFileArray()
                     AlertKitAPI.present(
                        title: "Deleted Video",
                        icon: .error,
                        style: .iOS17AppleMusic,
                        haptic: .error
                     )
                 }catch{
                     print(error.localizedDescription)
                 }
             }
             cell.shareVideo = {
                 DispatchQueue.main.async {
                     self.shareVideo(videoLink: URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent( self.downloadedFiles[indexPath.row].path as String)))
                 }
             }
     //        cell.shareButton.addTarget(self, action: #selector(shareVideo), for: UIControl.Event.touchUpInside)
             cell.titleLabel.text = downloadedFiles[(indexPath as NSIndexPath).row].path
             cell.getAllFrames()

             return cell
         }
       
    }
    func shareVideo(videoLink  : URL){

       let objectsToShare = [videoLink] //comment!, imageData!, myWebsite!]
       let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

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
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        
        let player = storyboard?.instantiateViewController(withIdentifier: "ASPPlayerViewController") as! PlayerViewController
         let fileName : NSString = downloadedFiles[(indexPath as NSIndexPath).row].path as NSString
        let fileURL  : URL = URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent(fileName as String))
        player.firstLocalVideoURL = fileURL
        player.modalPresentationStyle = .formSheet
        self.present(player, animated: true)
//        self.navigationController?.pushViewController(player, animated: true)
//        self.present(player, animated: true)
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fileName : NSString = downloadedFiles[(indexPath as NSIndexPath).row].path as NSString
        let fileURL  : URL = URL(fileURLWithPath: (myDownloadPath as NSString).appendingPathComponent(fileName as String))
        
        do {
            print(fileURL.absoluteString)
            if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
                // delete file
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    print("Could not delete file, probably read-only filesystem")
                }
            }
            downloadedFiles.remove(at: (indexPath as NSIndexPath).row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        } catch let error as NSError {
            debugPrint("Error while deleting file: \(error)")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
class DownloadedFileCell:UITableViewCell{
    @IBOutlet var shareButton:UIButton!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var photoImageView:UIImageView!
     var tableview:UITableView!
    var indexPath:IndexPath!

    var videoUrl:URL! // use your own url
    var frames:[UIImage] = []
    private var generator:AVAssetImageGenerator!

    var rootViewController:UIViewController!
    
    var deleteVideo:(()->())?
    var shareVideo:(()->())?

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
    
    
   @IBAction func clickMore(_ sender:UIButton) {
       let menu1 = HSMenu(icon: nil, title: "Save")
       let menu2 = HSMenu(icon: nil, title: "Share")
       let menu3 = HSMenu(icon: nil, title: "Rename")
       let menu4 = HSMenu(icon: nil, title: "Delete")
       let menuArray = [menu1, menu2, menu3, menu4]
//       HSPopupMenuArrowPosition
//       let rectOfCellInTableView = self.tableview.rectForRow(at: indexPath)
//       
//       
//       var  visibleCellsList=tableview.visibleCells
//       var  center:CGRect?
//
//       for  currentCell in visibleCellsList {
//           if currentCell == self{
//               center = currentCell.frame
//           }
//       }
////       let rectOfCellInSuperview = self.tableview.convert(rectOfCellInTableView, to: self.tableview.superview)
//       center = CGRect(origin: CGPoint(x: self.frame.origin.x + (center!.width - 21),y: self.frame.origin.y + 165), size: center!.size)
////       center?.origin = CGPoint(x: self.frame.origin.x + (center!.width - 21),y: self.frame.origin.y)
////       center = CGRect(x: self.frame.origin.x + (center!.width - 21), y: self.frame.origin.y, width: 0, height: 0)
//       let popupMenu = HSPopupMenu(menuArray: menuArray, arrowPoint:center!.origin)
//       popupMenu.arrowPosition = .left
////       popupMenu.arr
//               popupMenu.popUp()
//               popupMenu.delegate = self
//       
//       
//       
       
       
       
       let manager = PopMenuManager.default
              // Set actions
              manager.actions = [ PopMenuDefaultAction(title: "Save"),PopMenuDefaultAction(title: "Share"),PopMenuDefaultAction(title: "Rename"),PopMenuDefaultAction(title: "Delete")
              ]
              // Customize appearance
              manager.popMenuAppearance.popMenuFont = UIFont(name: "AvenirNext-DemiBold", size: 16)!
              manager.popMenuAppearance.popMenuBackgroundStyle = .blurred(.dark)
              manager.popMenuShouldDismissOnSelection = false
              manager.popMenuDelegate = self
              // Present menu
              manager.present(sourceView: sender)
   }
    
    
    
    func rename(name:String){
        do {
            let documentDirectory = videoUrl
//            let originPath = documentDirectory?.appendingPathComponent(videoUrl.lastPathComponent)
            
            let destinationPath = documentDirectory?.deletingLastPathComponent().appendingPathComponent(name+".mp4")
            try FileManager.default.moveItem(at: videoUrl!, to: destinationPath!)
            AlertKitAPI.present(
                title: "Rename Video Done !",
                icon: .done,
                style: .iOS17AppleMusic,
                haptic: .success
            )
        } catch {
            print(error)
        }
    }
    
    
    
    
}
extension DownloadedFileCell: HSPopupMenuDelegate {
    func popupMenu(_ popupMenu: HSPopupMenu, didSelectAt index: Int) {
        print("selected index is: " + "\(index)")
    }
}
extension DownloadedFileCell: PopMenuViewControllerDelegate {
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        // Use manager for pop menu
        switch index{
        case 0:
            
            saveVideoToLibrary(self.videoUrl)
        case 1:
           shareVideo!()
        case 2:
            let alert = SCLAlertView()
            let txt = alert.addTextField("Enter your name")
            alert.addButton("Rename") {
                self.rename(name: txt.text ?? "none")
                print("Text value: \(txt.text)")
            }
            alert.showEdit("Change Name", subTitle: "")
        case 3:
            
            deleteVideo!()
        default:
            break
        }
        popMenuViewController.dismiss(animated: true)
    }
    func saveVideoToLibrary(_ urlVideo:URL) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.save(urlVideo)
                } else {
                    
                }
            })
        }else{
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    self.save(urlVideo)
                } else {
                    
                }
            }
        }
    }
    
    
    func save(_ urlVideo:URL){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: urlVideo)
        }) { saved, error in
            if saved{
                DispatchQueue.main.async {
                    AlertKitAPI.present(
                        title: "Saved Video",
                        icon: .done,
                        style: .iOS17AppleMusic,
                        haptic: .success
                    )
                }
            }else{
                DispatchQueue.main.async {
                    AlertKitAPI.present(
                        title: "Faild to Save Video",
                        icon: .error,
                        style: .iOS17AppleMusic,
                        haptic: .error
                    )
                }
            }
           
            
        }
    }
}
