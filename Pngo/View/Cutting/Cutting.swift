//
//  Cutting.swift
//  Hero
//
//  Created by hassan duhair on 2/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import UIKit
import Photos
import GoogleMobileAds

protocol CuttingDelegate {
    func finish(success: Bool)
}

class Cutting{
    
    static var shared: Cutting!
    var delegate: CuttingDelegate!
    
    typealias TrimPoints = [(CMTime, CMTime)]
    typealias TrimCompletion = (Error?) -> ()
    var Seconds : Int! = 7
    
    func GetCMTimes(Duration : Float64 , SecondsToCut : Int)->[TrimPoints] {
        
        // 159 / 10 = 15.9
        // all are these seconds
        let number : Double = (Double(Duration) / Double(SecondsToCut))
        
        let Count = Int(number) + 1
        // but the last is this
        
        // test then return it
        // let New = Int(abs(Double(Int(number)) - number) * 10)
        
        var TTimes : [TrimPoints] = []
        
        for _ in 0..<Count {
            
            let CM1 = CMTimeMake(value: (Int64(TTimes.count * SecondsToCut)), timescale: 1)
            let CM2 = CMTimeMake(value: (Int64((TTimes.count * SecondsToCut) + SecondsToCut)), timescale: 1)
            TTimes.append([(CM1 , CM2)])
            
            if Count == TTimes.count {
                return TTimes
            }
            
        }
        
        return []
        
    }
    
    func GetVideoAndTrimIt(url : URL, fromVC: UIViewController) {
        
        let loadingView = RSLoadingView()
        loadingView.show(on: fromVC.view)
        
        let asset = AVAsset(url: url)
        let duration = asset.duration.seconds
        print(duration)
        
        let getTimes = self.GetCMTimes(Duration: duration, SecondsToCut: Seconds)
        
        
        for (index , one) in getTimes.enumerated() {
            
            var fileName = String(UUID().uuidString)
            if fileName.contains(".mp4") == false { fileName = fileName + UUID().uuidString + ".mp4" }
            else {
                let endIndex = fileName.index(fileName.endIndex, offsetBy: -4)
                let truncated = fileName.substring(to: endIndex)
                fileName = truncated + UUID().uuidString + ".mp4"
            }
            
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
            // your destination file url
            let destinationUrl = documentsUrl.appendingPathComponent(fileName)
            print(destinationUrl)
            
            self.trimVideo(sourceURL: url as NSURL, destinationURL: destinationUrl as NSURL, trimPoints: one , completion: { (Error) in
                if Error == nil {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationUrl)
                    }) { saved, error in
                        if saved {
                            if index == getTimes.count - 1 {
                                
                                RSLoadingView.hide(from: fromVC.view)
                                self.delegate.finish(success: true)
                                
                                /*
                                let alertController = UIAlertController(title: "تم حفظ المقاطع في الالبوم بنجاح", message: nil, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    self.delegate.finish(success: true)
                                })
                                
                                alertController.addAction(defaultAction)
                                fromVC.present(alertController, animated: true, completion: nil)
                                
                                */
                            }
                        }
                    }
                }
            })
        }
    }
    
    func trimVideo(sourceURL: NSURL, destinationURL: NSURL, trimPoints: TrimPoints, completion: TrimCompletion?) {
        
        guard sourceURL.isFileURL else { return }
        guard destinationURL.isFileURL else { return }
        
        let options = [
            AVURLAssetPreferPreciseDurationAndTimingKey: true
        ]
        
        let asset = AVURLAsset(url: sourceURL as URL, options: options)
        let preferredPreset = AVAssetExportPresetPassthrough
        
        if verifyPresetForAsset(preset: preferredPreset, asset: asset) {
            
            let composition = AVMutableComposition()
            let videoCompTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
            let audioCompTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
            
            guard let assetVideoTrack: AVAssetTrack = asset.tracks(withMediaType: AVMediaType.video).first else { return }
            guard let assetAudioTrack: AVAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else { return }
            
            var accumulatedTime = CMTime.zero
            for (startTimeForCurrentSlice, endTimeForCurrentSlice) in trimPoints {
                let durationOfCurrentSlice = CMTimeSubtract(endTimeForCurrentSlice, startTimeForCurrentSlice)
                let timeRangeForCurrentSlice = CMTimeRangeMake(start: startTimeForCurrentSlice, duration: durationOfCurrentSlice)
                
                do {
                    try videoCompTrack?.insertTimeRange(timeRangeForCurrentSlice, of: assetVideoTrack, at: accumulatedTime)
                    try audioCompTrack?.insertTimeRange(timeRangeForCurrentSlice, of: assetAudioTrack, at: accumulatedTime)
                    accumulatedTime = CMTimeAdd(accumulatedTime, durationOfCurrentSlice)
                }
                catch let compError {
                    print("TrimVideo: error during composition: \(compError)")
                    completion?(compError)
                }
            }
            
            guard let exportSession = AVAssetExportSession(asset: composition, presetName: preferredPreset) else { return }
            
            exportSession.outputURL = destinationURL as URL
            exportSession.outputFileType = AVFileType.m4v
            exportSession.shouldOptimizeForNetworkUse = true
            
            removeFileAtURLIfExists(url: destinationURL as URL)
            
            exportSession.exportAsynchronously {
                completion?(exportSession.error)
            }
        }
        else {
            print("TrimVideo - Could not find a suitable export preset for the input video")
            let error = NSError(domain: "com.bighug.ios", code: -1, userInfo: nil)
            completion?(error)
        }
    }
    
    func verifyPresetForAsset(preset: String, asset: AVAsset) -> Bool {
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: asset)
        let filteredPresets = compatiblePresets.filter { $0 == preset }
        return filteredPresets.count > 0 || preset == AVAssetExportPresetPassthrough
    }
    
    func removeFileAtURLIfExists(url: URL) {
        
        let fileManager = FileManager.default
        
        guard fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            try fileManager.removeItem(at: url)
        }
        catch let error {
            print("TrimVideo - Couldn't remove existing destination file: \(String(describing: error))")
        }
    }


}



