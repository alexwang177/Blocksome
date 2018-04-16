//
//  StartMenu.swift
//  Blocksome
//
//  Created by AlexWang1 on 4/2/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class StartMenu: SKScene{
    
    let tapStartLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    
    var title = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        title = (childNode(withName: "Title") as? SKLabelNode)!
        title.zPosition = 3
        
    // set background
        backgroundColor = SKColor.white
        
        // set size, color, position, and text of the tapStartLabel
        
        tapStartLabel.fontSize = 28
        tapStartLabel.fontColor = SKColor.black
        tapStartLabel.horizontalAlignmentMode = .center
        tapStartLabel.verticalAlignmentMode = .center
        //tapStartLabel.position = CGPoint(
           // x: size.width / 4,
            //y: size.height / 4
            
        //)
        tapStartLabel.text = "Tap to start the game"
        
        //add the label to the scene
        addChild(tapStartLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        GameViewController.scene.scaleMode = .aspectFill
        
        let gameScene = GameViewController.scene
        //gameScene?.scaleMode = scaleMode
        
        //use a transition to the gameScene
        let reveal = SKTransition.fade(withDuration: 1)
        
        //transition from current scene to the new scene
        view!.presentScene(gameScene!, transition: reveal)
        
    
    
    }
    
    

}

