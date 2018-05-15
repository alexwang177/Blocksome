//
//  PauseMenu.swift
//  Blocksome
//
//  Created by AlexWang1 on 4/16/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class PauseMenu: SKScene{
    
    var resumeButton = SKSpriteNode()
    
    override func didMove(to view: SKView){
        
        resumeButton = (childNode(withName: "resumeButton" ) as? SKSpriteNode)!
        resumeButton.name = "resumeButton"
        resumeButton.zPosition = 5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touches began in pause menu")
        
        let touch = touches.first // get the first touch
        selectNodeForTouch(touchLocation: (touch?.location(in: self))!)
        
       
        
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree)/180.0 * Double.pi)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint)
    {
        // print("touch")
        let touchedNode = scene?.atPoint(touchLocation)       //*******
        
        if touchedNode is SKSpriteNode{
            
            print("is a sprite")
            
            if(touchedNode?.name != nil)
            {
                if touchedNode?.name! == resumeButton.name {
                    print("RESUME WORKING")
                    
                        print("Transitioning back to game")
                        
                        //self.scene?.view?.isPaused = true
                        //GameScene.gameIsPaused = true
                        
                        //print("Transitioning to pause menu")
                        
                        //let pauseMenu = PauseMenu(fileNamed: "PauseMenu")
                    
                        let reveal = SKTransition.fade(withDuration: 1)
                    
                        let gameScene = GameViewController.scene
                        
                        self.view!.presentScene(gameScene!, transition: reveal)
                        
                        GameScene.gameIsPaused = false
                    
                    
                    
                }
            }


    
}
}
}
