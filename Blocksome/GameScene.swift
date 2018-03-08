//
//  GameScene.swift
//  Blocksome
//
//  Created by AlexWang1 on 1/30/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

private let kBlockNodeName = "movable"

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var g: Int = 1
    
    /*var player: Player {
        willSet(newValue){
            
        }
        didSet(oldValue){
    
        }
    }*/
    
    var player = Player()
    
    var level: Level?
    
    //let TileWidth: CGFloat = (CGFloat)((Int)(screenWidth)/NumColumns)    //34.0
    //let TileHeight: CGFloat = (CGFloat)((Int)(screenHeight)/NumRows) //36.0
    
    let TileWidth: CGFloat = 26.00   //34.0
    let TileHeight: CGFloat = 26.25
    
    let background = SKSpriteNode(imageNamed: "BackgroundBlue")
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    let blocksLayer = SKNode()
    
    let playerLayer = SKNode()
    
    var playerSprite = SKSpriteNode()

    var selectedNode = SKSpriteNode()
    
   /*required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
        //super.init(coder: aDecoder)
       //setup()
        
    }*/
    
    override func didMove(to view: SKView) {
        
        scheduledTimerWithTimerInterval()
        
        physicsWorld.contactDelegate = self
        
        self.player = Player(column: 10, row: 10)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //background = SKSpriteNode(imageNamed: "BackgroundBlue")
        playerSprite = SKSpriteNode(imageNamed: "Tile")
        
        self.background.name = "background"
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.size = size
        self.addChild(background)
        
        
        // Add a new node that is the container for all other layers on the playing
        // field. This gameLayer is also centered in the screen.
        self.addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns)/2,
            y: -TileHeight * CGFloat(NumRows)/2)
        
        // The tiles layer represents the shape of the level. It contains a sprite
        // node for each square that is filled in.
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        // This layer holds the Cookie sprites. The positions of these sprites
        // are relative to the cookiesLayer's bottom-left corner.
        blocksLayer.position = layerPosition
        gameLayer.addChild(blocksLayer)
        
        playerLayer.position = layerPosition
        gameLayer.addChild(playerLayer)
        
        // sets all the layers' z-positions
        
        background.zPosition = 0
        tilesLayer.zPosition = 1
        blocksLayer.zPosition = 2
        playerLayer.zPosition = 3
        
        
    }
    
    // LEVEL SETUP
    func addTiles(){
        for row in 0..<NumRows{
            for column in 0..<NumColumns {
                // If there is a tile at this position, then create a new tile
                // sprite and add it to the mask layer.
                if level?.tileAt(column: column, row: row) != nil{
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tilesLayer.addChild(tileNode)
                    
                    /*print("ScreenWidth: \(screenWidth)")
                    print("TileWidth: \((Int)(screenWidth)/NumColumns)")
                    print("ScreenHeight: \(screenHeight)")
                    print("TileHeight: \((Int)(screenHeight)/NumRows)")*/
                }
                else{
                    print("Empty tile lolz")
                    //print("TileWidth: \(TileWidth)")
                    //print("TileHeight: \(TileHeight)")
                }
            }
        }
    }
    
    func addSprites(for blocks: Set<Block>){
        for block in blocks {
            // Create a new sprite for the cookie and add it to the cookiesLayer.
            let sprite = SKSpriteNode(imageNamed: block.blockType.spriteName)
            
            sprite.name = kBlockNodeName
            
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: block.column, row: block.row)
            blocksLayer.addChild(sprite)
            block.sprite = sprite
            
        }
    }
    
    func addPlayer()
    {
        player = Player(column: player.column, row: player.row)
        //let sprite = SKSpriteNode(imageNamed: "Tile")
        
        playerSprite.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
        playerSprite.position = pointFor(column: player.column, row: player.row)
        playerLayer.addChild(playerSprite)
        player.sprite = playerSprite
        
        print("ADDED PLAYER")
    }
    
    func updatePlayer()
    {
        //player = Player(column: player.column, row: player.row)
        //let sprite = SKSpriteNode(imageNamed: "Tile")
        
        playerSprite.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        playerSprite.position = pointFor(column: player.column, row: player.row)
        //playerLayer.addChild(sprite)
        player.sprite = playerSprite
        //playerLayer.childNode(withName: "sprite")?.position = sprite.position
        
        print("UPDATED PLAYER")
    }
    
    // MARK: Point conversion
    
    // Converts a column,row pair into a CGPoint that is relative to the cookieLayer.
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2
        )
    }
    
    // Sprite Touch Selection
    
    /*func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        print("touches began")
        let touch = touches.anyObject() as! UITouch
        let positionInScene = touch.location(in: blocksLayer)
        
        selectNodeForTouch(touchLocation: positionInScene)
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        if let touch = touches.first {
            let positionInScene = touch.location(in: blocksLayer)
            print("touches began works")
            
            selectNodeForTouch(touchLocation: positionInScene)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree)/180.0 * Double.pi)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint)
    {
        print("touch")
        let touchedNode = blocksLayer.atPoint(touchLocation)       //*******
        
        if touchedNode is SKSpriteNode{
            print("is a sprite")
            
            if !selectedNode.isEqual(touchedNode){
                print("same sprite")
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                
                if touchedNode.name! == kBlockNodeName {
                    print("wiggle")
                    let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(degree: -10.0), duration: 0.1),
                                                      SKAction.rotate(byAngle: 0.0, duration: 0.1),
                                                      SKAction.rotate(byAngle: degToRad(degree: 10.0), duration: 0.1)])
                    selectedNode.run(SKAction.repeatForever(sequence))
                    
                }
            }
        }
        
    }
    
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        
        if selectedNode.name == kBlockNodeName {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            background.position = self.boundLayerPos(aNewPosition: aNewPosition)
        }
    }
    
    /*func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        print("touches MOVED")
        let touch = touches.anyObject() as! UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        panForTranslation(translation: translation)
    }*/
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches MOVED")
        if let touch = touches.first
        {
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        panForTranslation(translation: translation)
        }
    }
    
    /*var oldUpdateTime: TimeInterval = 0
    
    override func update(_ currentTime: TimeInterval)
    {
        let delta: TimeInterval = 1
        if currentTime - oldUpdateTime > delta {
        
        g = g+1
        print("G: \(g)")
        }
        
    }*/
    
    var timer = Timer()
    
    func scheduledTimerWithTimerInterval(){
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting()
    {
        NSLog("counting... \(g)")
        g = g+1
        
        if (player.row + player.ySpeed >= 1) && (player.row + player.ySpeed <= NumRows-2)
        {
            player.row = player.row + player.ySpeed
        }
        
        if (player.column + player.xSpeed >= 1) && (player.column + player.xSpeed <= NumColumns-2)
        {
            player.column = player.column + player.xSpeed
        }
        
        //playerLayer.removeAllChildren()
        
        updatePlayer()
        
    }
    

    
}

