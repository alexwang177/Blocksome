//
//  Unarchive.swift
//  Blocksome
//
//  Created by AlexWang1 on 3/7/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks"){
            let sceneData = NSData(contentsOfFile: path)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData! as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}
