//
//  DWRecorderController.swift
//  Recorder
//
//  Created by Trinity on 16/8/28.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit
import AVFoundation

typealias DWRecordingStopCompletionHandler = (success: Bool) -> Void
typealias DWRecordingSaveCompletionHandler = (success: Bool) throws -> Void
class DWRecorderController: NSObject, AVAudioRecorderDelegate {
    var recorder: AVAudioRecorder?
    var completionHandler: DWRecordingStopCompletionHandler?
    
    override init() {
        super.init()
    
        let tempDir = NSTemporaryDirectory()
        var url = NSURL(string: tempDir)
        url = url?.URLByAppendingPathComponent("memo.caf")
        
        kAudioFormatAppleIMA4
        let settings: [String: AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleIMA4),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitDepthHintKey: 16,
            AVEncoderAudioQualityKey: NSNumber(integer: AVAudioQuality.Medium.rawValue),
        ]
        
        if let url = url {
            recorder = try? AVAudioRecorder(URL: url, settings: settings)
        }
        
        if let recorder = recorder {
            recorder.delegate = self
            self.recorder?.prepareToRecord()
        } else {
            fatalError(#function)
        }
    }
    
    func record() -> Bool {
        guard let recorder = recorder else { return false }
        return recorder.record()
    }
    
    func pause() {
        recorder?.pause()
    }
    
    func stopWithCompletionHandler(handler: DWRecordingStopCompletionHandler?) {
        completionHandler = handler
        recorder?.stop()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        completionHandler?(success: flag)
    }
    
    func saveRecordingWithName(name: String, completionHandler: DWRecordingSaveCompletionHandler?) {
        let timestamp = NSDate.timeIntervalSinceReferenceDate()
        let filename = String(format: "%@-%.0f.mp3", name,timestamp)
        
        guard let path = recorder?.url.path else { return }
        let srcURL = NSURL.fileURLWithPath(path)
        if let desURL = NSURL.documentsDirectory()?.URLByAppendingPathComponent(filename)
        {
            do {
                try NSFileManager.defaultManager().copyItemAtURL(srcURL, toURL: desURL)
                let _ = try? completionHandler?(success: true)
            } catch {
                let _ = try? completionHandler?(success: false)
            }
        }
        
    }
    
    func formattedCurrentTIme() -> String? {
        guard let recorder = recorder else { return "00:00:00" }
        let time = UInt32(recorder.currentTime)
        return String(format: "%02d:%02d:%02d", time / 3600, (time / 60) % 60, time % 60)
    }
}























