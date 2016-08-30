//
//  NSURL+.swift
//  Recorder
//
//  Created by Trinity on 16/8/28.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import Foundation

extension NSURL {
    class func documentsDirectory() -> NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    }
}
