//
//  GameViewController.swift
//  Blocksome
//
//  Created by AlexWang1 on 1/30/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // MARK: Properties
    
    // The scene draws the tiles and cookie sprites, and handles swipes.
    var scene: GameScene!
    
    // The level contains the tiles, the cookies, and most of the gameplay logic.
    // Needs to be ! because it's not set in init() but in viewDidLoad().
    var level: Level!
    
    // VIEW CONTROLLER FUNCTIONS
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
 
        return [.portrait, .portraitUpsideDown]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsNodeCount = true
        skView.showsFPS = true
        skView.isUserInteractionEnabled = true
        skView.ignoresSiblingOrder = true
        
        
        // Create and configure the scene.
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        //Load the Level
        level = Level(filename: "Level_1")
        scene.level = level
        
        scene.addTiles()
        
        // Present the scene.
        skView.presentScene(scene)
        
        //start game
        beginGame()
    }
    
      // MARK: Game functions
    
    func beginGame(){
        shuffle()
    }
    
    func shuffle(){
        // Fill up the level with new blocks, and create sprites for them.
        let newBlocks = level.shuffle()
        scene.addSprites(for: newBlocks)
    }


}
