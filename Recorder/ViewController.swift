//
//  ViewController.swift
//  Recorder
//
//  Created by Trinity on 16/8/28.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var _cache: AnyObject!
    var cache: AnyObject! {
        get {
            if _cache == nil {
                _cache = {
                    var t: AnyObject?
                    if let path = NSURL.documentsDirectory()?.path {
                        t = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(NSURL(fileURLWithPath: path), includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
                    }
                    return t
                }()
            }
            return _cache
        }
        
        set {
            _cache = newValue
        }
    }

    @IBOutlet weak var tableView: UITableView!
    var recorderController: DWRecorderController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorderController = DWRecorderController()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if tableView.contentOffset.y > 100 {
            print("reload")
            cache = nil
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        let _ = try? NSFileManager.defaultManager().removeItemAtURL((cache as! [NSURL])[indexPath.row])
        cache = nil
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
//        tableView.reloadData()
        tableView.endUpdates()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cache as! [NSURL]).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recorderCell") ?? UITableViewCell()
        guard let item = (cache as? [NSURL])?[indexPath.row] else { fatalError() }
        cell.textLabel?.text = item.lastPathComponent
        print(item.lastPathComponent)
        return cell
    }
    
    // MARK: - Action
    @IBAction func stop(sender: AnyObject) {
        recorderController?.stopWithCompletionHandler(nil)
//        recorderController?.saveRecordingWithName("Untitled", completionHandler: )
        recorderController?.saveRecordingWithName("Untitled", completionHandler: { [weak self] (success) in
            if success {
                self?.cache = nil
                self?.tableView.reloadData()
            }
        })
    }
    
    @IBAction func record(sender: AnyObject) {
        recorderController?.record()
    }
    
}

