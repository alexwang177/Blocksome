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
    
    // THIS IS THE START SCENE
    var startMenu:  StartMenu!
    
    // The scene draws the tiles and cookie sprites, and handles swipes.
    public static var scene: GameScene!
    
    // The level contains the tiles, the cookies, and most of the gameplay logic.
    // Needs to be ! because it's not set in init() but in viewDidLoad().
    var level: Level!
    
    // Arrow Key Instance Variables
    var leftPressed = false
    var rightPressed = false
    var upPressed = false
    var downPressed = false
    
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
        
        startMenu = StartMenu(fileNamed: "StartMenu")
        
        GameViewController.scene = GameScene(fileNamed: "GameScene")
        
        // Configure the view.
        
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsNodeCount = true
        skView.showsFPS = true
        skView.isUserInteractionEnabled = true
        skView.ignoresSiblingOrder = true

        
        
        
        // Create and configure the scene.
        
        //scene = GameScene(size: skView.bounds.size)
        //scene = GameScene(fileNamed: "GameScene")
        //scene = GameScene(fileNamed: "GameScene.sks", size: skView.bounds.size)
        
        //scene = GameScene.unarchiveFromFile(file: "GameScene") as! GameScene
        
        GameViewController.scene.scaleMode = .aspectFill
        
        //Load the Level
        level = Level(filename: "Level_1")
        GameViewController.scene.level = level
        
        GameViewController.scene.addTiles()
        
        //Swipe gestures
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    
        // Present the scene.
        skView.presentScene(startMenu)
        
        //start game
        beginGame()
    }
    
      // MARK: Game functions
    
    func beginGame(){
        shuffle()
        GameViewController.scene.addPlayer()
    }
    
    func shuffle(){
        // Fill up the level with new blocks, and create sprites for them.
        let newBlocks = level.shuffle()
        GameViewController.scene.addSprites(for: newBlocks)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if(GameScene.gameIsPaused == false)
        {
        
            if gesture.direction == UISwipeGestureRecognizerDirection.right && GameViewController.scene.player.playerDirection != "left"{
           // print("Swipe Right")
                GameViewController.scene.player.xSpeed = 1
                GameViewController.scene.player.ySpeed = 0
            
                GameViewController.scene.player.playerDirection = "right"
                GameViewController.scene.player.playerBodyDirections[0] = "right"
                
            }
        
            if gesture.direction == UISwipeGestureRecognizerDirection.left && GameViewController.scene.player.playerDirection != "right"{
               // print("Swipe Left")
                GameViewController.scene.player.xSpeed = -1
                GameViewController.scene.player.ySpeed = 0
                
                GameViewController.scene.player.playerDirection = "left"
                GameViewController.scene.player.playerBodyDirections[0] = "left"
            }
        
        
            if gesture.direction == UISwipeGestureRecognizerDirection.up && GameViewController.scene.player.playerDirection != "down"{
               // print("Swipe Up")
                GameViewController.scene.player.xSpeed = 0
                GameViewController.scene.player.ySpeed = 1
                GameViewController.scene.player.playerDirection = "up"
                GameViewController.scene.player.playerBodyDirections[0] = "up"
            }
            
            
            if gesture.direction == UISwipeGestureRecognizerDirection.down && GameViewController.scene.player.playerDirection != "up"{
               // print("Swipe Down")
                GameViewController.scene.player.xSpeed = 0
                GameViewController.scene.player.ySpeed = -1
                
                GameViewController.scene.player.playerDirection = "down"
                GameViewController.scene.player.playerBodyDirections[0] = "down"
            }
        }
    }
    
    // Arrow Key Movement
    

    
}
