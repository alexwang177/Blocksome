//
//  Extensions.swift
//  Blocksome
//
//  Created by AlexWang1 on 2/7/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import Foundation
import SpriteKit

extension Dictionary {
    
    // Loads a JSON file from the app bundle into a new dictionary
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        var dataOK: Data
        var dictionaryOK: NSDictionary = NSDictionary()
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions()) as Data!
                dataOK = data!
            }
            catch {
                print("Could not load level file: \(filename), error: \(error)")
                return nil
            }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: dataOK, options: JSONSerialization.ReadingOptions()) as AnyObject!
                dictionaryOK = (dictionary as! NSDictionary as? Dictionary<String, AnyObject>)! as NSDictionary
            }
            catch {
                print("Level file '\(filename)' is not valid JSON: \(error)")
                return nil
            }
        }
        return dictionaryOK as? Dictionary<String, AnyObject>
    }
    
}

import SpriteKit

extension SKSpriteNode {
    
    func addGlow(radius: Float){
        
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        self.addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        
        for x in 0...5{
        
            effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius + Float(10*x)])
        }
        
        
        
        }
    

    




}
