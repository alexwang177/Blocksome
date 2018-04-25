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
    
    //@IBOutlet weak var scoreLabel: SKLabelNode!
    
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
    
    let TileWidth: CGFloat = 47//26.00
    let TileHeight: CGFloat = 47.75//26.25
    
    let background = SKSpriteNode(imageNamed: "BackgroundBlue")
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    let blocksLayer = SKNode()
    
    let playerLayer = SKNode()
    
    let infoLayer = SKNode()
    
    var score = SKLabelNode()
    
    var pauseButton = SKSpriteNode()
    
    public static var gameIsPaused: Bool = false
    
    var scoreNumber: Int = 0
    
    var magic = SKEmitterNode(fileNamed: "MagicParticle.sks")
    
    var playerSprite = SKSpriteNode()
    
    var _possiblePositionsForNewBodyParts: [CGPoint]?
    
    var positionOfNewBodyPart: [SKSpriteNode]!
    
    var newBlockColor: Int?
    
    var obstacle = SKSpriteNode()

    var selectedNode = SKSpriteNode()
    
    let bodyPart = SKSpriteNode(imageNamed : "RedOrb")
    
    let bodyPart2 = SKSpriteNode(imageNamed : "OrangeOrb")
    let bodyPart3 = SKSpriteNode(imageNamed : "YellowOrb")
    let bodyPart4 = SKSpriteNode(imageNamed : "GreenOrb")
    let bodyPart5 = SKSpriteNode(imageNamed : "BlueOrb")
    let bodyPart6 = SKSpriteNode(imageNamed : "IndigoOrb")
    let bodyPart7 = SKSpriteNode(imageNamed : "PurpleOrb")
    
    var playerBody: [SKSpriteNode]!
    
    var glowRadius: Float = 10.0
    
   /*required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
        //super.init(coder: aDecoder)
       //setup()
        
    }*/
    
    override func didMove(to view: SKView) {
        
        scheduledTimerWithTimerInterval()
        
        physicsWorld.contactDelegate = self
        
        self.player = Player(column: 10, row: 10)
        
        self.positionOfNewBodyPart = []
        
        //self.player = Player(column: 10, row: 10)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        playerSprite = SKSpriteNode(imageNamed: "Tile")
        
        
        /*self.background.name = "background"
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.size = self.size
        self.addChild(background)*/
        
        backgroundColor = SKColor.black
        
        //Glowing
        
        magic?.name = "magic"
        magic?.position = bodyPart.position
        
        //magic?.alpha = 0.0
        
        playerLayer.addChild(magic!)
        
        //bodyPart.addGlow(radius: 10.0)
        //bodyPart2.addGlow()
        
        //Block Sizes
        bodyPart.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart.name = "Red"
        bodyPart2.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart2.name = "Orange"
        bodyPart3.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart3.name = "Yellow"
        bodyPart4.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart4.name = "Green"
        bodyPart5.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart5.name = "Blue"
        bodyPart6.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart6.name = "Indigo"
        bodyPart7.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart7.name = "Purple"
        
        self.playerBody = [bodyPart, bodyPart2, bodyPart3, bodyPart4, bodyPart5, bodyPart6, bodyPart7]
        
        
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

        infoLayer.position = layerPosition
        gameLayer.addChild(infoLayer)
        
        score = (childNode(withName: "Score") as? SKLabelNode)!
        score.zPosition = 3
        
        score.text = "LOL"
        
        scoreNumber = 0
        
        pauseButton = (childNode(withName: "pauseButton" ) as? SKSpriteNode)!
        pauseButton.name = "pauseButton"
        //pauseButton.isUserInteractionEnabled = true
        pauseButton.zPosition = 3
        
        //infoLayer.addChild(score)
        
        
        //playerLayer.addChild(obstacle)
        
        // sets all the layers' z-positions
        
        background.zPosition = 0
        tilesLayer.zPosition = 1
        blocksLayer.zPosition = 2
        playerLayer.zPosition = 3
        infoLayer.zPosition = 3
        
        // SET GAME INTIALLY UNPAUSED
        self.scene?.view?.isPaused = false
        
        
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
        
        playerSprite.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
        playerSprite.position = pointFor(column: player.column, row: player.row)
        player.sprite = playerSprite
        
        
       // let playerBodyPartsContainer = SKNode()
        //playerBodyPartsContainer.name = "playerBodyPartsContainer"
        
      //addChild(playerBodyPartsContainer)
        
       playerBody = [bodyPart, bodyPart2, bodyPart3, bodyPart4, bodyPart5, bodyPart6, bodyPart7]
        
        for bodyPart in playerBody {
            bodyPart.removeFromParent()
            playerLayer.addChild(bodyPart)
            //print(bodyPart)
        }
        
        let newBodyPartsContainer = SKNode()
        newBodyPartsContainer.name = "newBodyPartsContainer"
        addChild(newBodyPartsContainer)
    }
    
//    func updatePlayer()
//    {
//        //player = Player(column: player.column, row: player.row)
//        //let sprite = SKSpriteNode(imageNamed: "Tile")
//
//        playerSprite.size = CGSize(width: player.playerWidth, height: player.playerHeight)
//        playerSprite.position = pointFor(column: player.column, row: player.row)
//
//        //playerLayer.addChild(sprite)
//        player.sprite = playerSprite
//
//        //playerLayer.childNode(withName: "sprite")?.position = sprite.position
//
//        print("UPDATED PLAYER")
//    }
    
    func movePlayer(){
        guard let headPositionColumn = player.playerBodyPartsColumn.first else{return}
        
        guard let headPositionRow = player.playerBodyPartsRow.first else{return}
        
        switch player.playerDirection{
        case "up":
            if(headPositionRow != 24)
            {
            player.playerBodyPartsRow.insert(headPositionRow + 1, at: 0)
            player.playerBodyPartsColumn.insert(headPositionColumn, at: 0)
            }
            else {
                removePlayerFromScreen()
                reset()
            }
        case "down":
            if(headPositionRow != 1)
            {
            player.playerBodyPartsRow.insert(headPositionRow - 1, at: 0)
            player.playerBodyPartsColumn.insert(headPositionColumn, at: 0)
            }
            else {
                removePlayerFromScreen()
                reset()
            }
        case "left":
            if(headPositionColumn != 1)
            {
            player.playerBodyPartsColumn.insert(headPositionColumn - 1, at: 0)
            player.playerBodyPartsRow.insert(headPositionRow , at: 0)
            }
            else {
                removePlayerFromScreen()
                reset()
            }
        case "right":
            if(headPositionColumn != 14)
            {
            player.playerBodyPartsColumn.insert(headPositionColumn + 1, at: 0)
            player.playerBodyPartsRow.insert(headPositionRow , at: 0)
            }
            else {
                removePlayerFromScreen()
                reset()
            }
        default:
            print("There has been a fatal error in move player regarding playerDirection")
        }
//        for bodyPart in playerBody {
//            print("REEEEEAALLLL BODYYY BRO \(bodyPart)")
//        }
    }
    
    func updatePositionOfBodyParts(){
//        if(playerBody[0].position == pointFor(column: player.playerBodyPartsColumn[0], row: player.playerBodyPartsRow[0]))
//        {
        for i in 0..<player.playerBodyPartsColumn.count{
            
            if i < playerBody.count{
                
                //  print("PLAYERCOLUMN - \(i) :  \(player.playerBodyPartsRow[i])")
                //print("PLAYERBODY  -  \(i) :  \(playerBody[i].position)")
                let bodyPart = playerBody[i]
                bodyPart.position = pointFor(column: player.playerBodyPartsColumn[i], row: player.playerBodyPartsRow[i])
                //print("BODY  -  \(i) :  \(bodyPart.position)")
                
                playerBody[i].position = bodyPart.position
                
                print("Head Row: \(player.playerBodyPartsRow[0])   Head Column: \(player.playerBodyPartsColumn[0]) ")
              //  print("Head Position: \(pointFor(column: player.playerBodyPartsColumn[0], row: player.playerBodyPartsRow[0]))")
            }
                
            else{
                player.playerBodyPartsColumn.removeLast()
                player.playerBodyPartsRow.removeLast()
            }
        }
        //}
        
        //print("LKJDFLKSDJFLSDFJSDLKJSDF:SDLFJSD:LFKJ:SDKJF \(playerBody)")
    }
    
    
    fileprivate func putNewBodyPartIfNeeded() {
        if (positionOfNewBodyPart.count != 5)
        {
            putNewBodyParts()
            print(positionOfNewBodyPart.count)
        }
    }
    
    private func putNewBodyParts() {
        
      //  guard let container = childNode(withName: "newBodyPartsContainer") else { return }
        
        let possiblePositions = positionsForNewBodyParts
        let randPositionIndex = arc4random_uniform(UInt32(possiblePositions.count))
        let randPosition = possiblePositions[Int(randPositionIndex)]
        
        newBlockColor = Int(arc4random_uniform(7)) + 1
        
        let newBodyPart: SKSpriteNode
        
        if(newBlockColor == 1)
        {
            newBodyPart = SKSpriteNode(imageNamed : "RedOrb")
            newBodyPart.name = "Red"
        }
        else if(newBlockColor == 2){
            newBodyPart = SKSpriteNode(imageNamed : "OrangeOrb")
            
            newBodyPart.name = "Orange"
        }
        else if(newBlockColor == 3){
            newBodyPart = SKSpriteNode(imageNamed : "YellowOrb")
            
            newBodyPart.name = "Yellow"
        }
        else if(newBlockColor == 4){
            newBodyPart = SKSpriteNode(imageNamed : "GreenOrb")
            newBodyPart.name = "Green"}
        else if(newBlockColor == 5){
            newBodyPart = SKSpriteNode(imageNamed : "BlueOrb")
            newBodyPart.name = "Blue"}
        else if(newBlockColor == 6){
            newBodyPart = SKSpriteNode(imageNamed : "PurpleOrb")
            newBodyPart.name = "Purple"}
        else{
            newBodyPart = SKSpriteNode(imageNamed : "IndigoOrb")
            newBodyPart.name = "Indigo"
            
        }
        
        newBodyPart.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
        newBodyPart.position = randPosition
        //print("This is the new body part position: \(newBodyPart.position)")
        
        positionOfNewBodyPart.append(newBodyPart)
        
       // container.addChild(newBodyPart)
        playerLayer.addChild(newBodyPart)
        
        print("This is the new body part position: \(newBodyPart.position)")
    }
    
    fileprivate var positionsForNewBodyParts: [CGPoint] {
        
//        if let alreadyCalculatedPositions = _possiblePositionsForNewBodyParts {
//            return alreadyCalculatedPositions
//        }
        
        var positions: [CGPoint] = []
        
        var playerBodyPositions: [CGPoint] = []
        var newBodyPositions: [CGPoint] = []
        
        for intersect in 0..<playerBody.count{
            playerBodyPositions.append(playerBody[intersect].position)
           // print(intersect)
        }
        
        for intersect in 0..<positionOfNewBodyPart.count{
            newBodyPositions.append(positionOfNewBodyPart[intersect].position)
        }
        var nextTo = false
        for row in 1...24{
            for column in 1...14{
                
                    if(playerBodyPositions.contains(pointFor(column: column, row: row)) == false && newBodyPositions.contains(pointFor(column: column, row: row)) == false && row != 24 && row != 1 && column != 14 && column != 1)
                    {
                        for check in newBodyPositions{
                            let delta = CGPoint(x: abs(pointFor(column: column, row: row).x - check.x), y: abs(pointFor(column: column, row: row).y - check.y))
                            
                            if(delta.x == player.playerWidth || delta.y == player.playerHeight)
                            {
                                nextTo = true
                            }
                        }
                        if(nextTo == false)
                        {
                        positions.append(pointFor(column: column, row: row))
                        }
                        
                        nextTo = false
                    }
            }
        }
    
        _possiblePositionsForNewBodyParts = positions
        return positions
    }
    
    func growSnakeIfNeeded() {
//        guard let playerNew = childNode(withName: "playerBodyPartsContainer") else { return }
        let positionOfHead  = pointFor(column: player.playerBodyPartsColumn[0], row: player.playerBodyPartsRow[0])
        
        //magic?.position = positionOfHead
        
        var partsToBeRemoved: [SKSpriteNode]?
        partsToBeRemoved = []
        
        
        for collectablePart in positionOfNewBodyPart
        {
        
            //let collectablePart = positionOfNewBodyPart[index]
            
           // print(collectablePart)
//        let delta = CGPoint(x: abs(positionOfHead.x - collectablePart.position.x), y: abs(positionOfHead.y - collectablePart.position.y))
        let delta = CGPoint(x: positionOfHead.x - collectablePart.position.x, y: positionOfHead.y - collectablePart.position.y)
        
       //print(delta)
        
        if player.playerDirection == "up"{
            if delta.x == 0 {
            if delta.y == -47.75 {
                
                magic?.position = positionOfHead
                
                //magic?.alpha = 0.2
                    
//              let partForAppending: SKSpriteNode
//
//                if(newBlockColor == 1)
//                {
//                    partForAppending = SKSpriteNode(imageNamed : "RedBlock")
//                }
//                else if(newBlockColor == 2){
//                    partForAppending = SKSpriteNode(imageNamed : "OrangeBlock")}
//                else if(newBlockColor == 3){
//                    partForAppending = SKSpriteNode(imageNamed : "YellowBlock")}
//                else if(newBlockColor == 4){
//                    partForAppending = SKSpriteNode(imageNamed : "GreenBlock")}
//                else if(newBlockColor == 5){
//                    partForAppending = SKSpriteNode(imageNamed : "BlueBlock")}
//                else if(newBlockColor == 6){
//                    partForAppending = SKSpriteNode(imageNamed : "PurpleBlock")}
//                else{
//                    partForAppending = SKSpriteNode(imageNamed : "IndigoBlock")}
//
//
//
//
//                partForAppending.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
//          //  print(playerBody.count)
//                partForAppending.position = collectablePart.position
                //print(collectablePart)
                
                let partForAppending = SKSpriteNode()
                partForAppending.texture = collectablePart.texture
                partForAppending.position = collectablePart.position
                partForAppending.size = collectablePart.size
                partForAppending.name = collectablePart.name
                
                playerBody.insert(partForAppending, at: 0)
                playerLayer.addChild(partForAppending)
                
                partsToBeRemoved?.append(collectablePart)
                
                scoreNumber = scoreNumber + 1
                
               // positionOfNewBodyPart[index].removeFromParent()
               // positionOfNewBodyPart.remove(at: index)
                //print(positionOfNewBodyPart.count)
                
//            for bodyPart in playerBody {
//                bodyPart.removeFromParent()
//                playerLayer.addChild(bodyPart)
//                //print(bodyPart)
//                }
                
                movePlayer()
                    
                    
            collectablePart.removeFromParent()
                    
                    
              
                }
            }
        }
        
        else if player.playerDirection == "down"{
            if delta.x == 0 {
                if delta.y == 47.75 {
                    
                    magic?.position = positionOfHead
                    //magic?.alpha = 0.2
                    
                    //              let partForAppending: SKSpriteNode
                    //
                    //                if(newBlockColor == 1)
                    //                {
                    //                    partForAppending = SKSpriteNode(imageNamed : "RedBlock")
                    //                }
                    //                else if(newBlockColor == 2){
                    //                    partForAppending = SKSpriteNode(imageNamed : "OrangeBlock")}
                    //                else if(newBlockColor == 3){
                    //                    partForAppending = SKSpriteNode(imageNamed : "YellowBlock")}
                    //                else if(newBlockColor == 4){
                    //                    partForAppending = SKSpriteNode(imageNamed : "GreenBlock")}
                    //                else if(newBlockColor == 5){
                    //                    partForAppending = SKSpriteNode(imageNamed : "BlueBlock")}
                    //                else if(newBlockColor == 6){
                    //                    partForAppending = SKSpriteNode(imageNamed : "PurpleBlock")}
                    //                else{
                    //                    partForAppending = SKSpriteNode(imageNamed : "IndigoBlock")}
                    //
                    //
                    //
                    //
                    //                partForAppending.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
                    //          //  print(playerBody.count)
                    //                partForAppending.position = collectablePart.position
                    //print(collectablePart)
                    
                    let partForAppending = SKSpriteNode()
                    partForAppending.texture = collectablePart.texture
                    partForAppending.position = collectablePart.position
                    partForAppending.size = collectablePart.size
                    partForAppending.name = collectablePart.name
                    
                    playerBody.insert(partForAppending, at: 0)
                    playerLayer.addChild(partForAppending)
                    
                    partsToBeRemoved?.append(collectablePart)
                    
                    scoreNumber = scoreNumber + 1
                    
                    // positionOfNewBodyPart[index].removeFromParent()
                    // positionOfNewBodyPart.remove(at: index)
                    //print(positionOfNewBodyPart.count)
                    
                    //            for bodyPart in playerBody {
                    //                bodyPart.removeFromParent()
                    //                playerLayer.addChild(bodyPart)
                    //                //print(bodyPart)
                    //                }
                    
                    movePlayer()
                    
                    
                    collectablePart.removeFromParent()
                    
                    
                    
                    
                }
            }
        }
        
        
        else if player.playerDirection == "left" {
            if delta.x == 47 {
                if delta.y == 0 {
                    
                    magic?.position = positionOfHead
                    //magic?.alpha = 0.2
                    
                    //              let partForAppending: SKSpriteNode
                    //
                    //                if(newBlockColor == 1)
                    //                {
                    //                    partForAppending = SKSpriteNode(imageNamed : "RedBlock")
                    //                }
                    //                else if(newBlockColor == 2){
                    //                    partForAppending = SKSpriteNode(imageNamed : "OrangeBlock")}
                    //                else if(newBlockColor == 3){
                    //                    partForAppending = SKSpriteNode(imageNamed : "YellowBlock")}
                    //                else if(newBlockColor == 4){
                    //                    partForAppending = SKSpriteNode(imageNamed : "GreenBlock")}
                    //                else if(newBlockColor == 5){
                    //                    partForAppending = SKSpriteNode(imageNamed : "BlueBlock")}
                    //                else if(newBlockColor == 6){
                    //                    partForAppending = SKSpriteNode(imageNamed : "PurpleBlock")}
                    //                else{
                    //                    partForAppending = SKSpriteNode(imageNamed : "IndigoBlock")}
                    //
                    //
                    //
                    //
                    //                partForAppending.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
                    //          //  print(playerBody.count)
                    //                partForAppending.position = collectablePart.position
                    //print(collectablePart)
                    
                    let partForAppending = SKSpriteNode()
                    partForAppending.texture = collectablePart.texture
                    partForAppending.position = collectablePart.position
                    partForAppending.size = collectablePart.size
                    partForAppending.name = collectablePart.name
                    
                    playerBody.insert(partForAppending, at: 0)
                    playerLayer.addChild(partForAppending)
                    
                    partsToBeRemoved?.append(collectablePart)
                    
                    scoreNumber = scoreNumber + 1
                    
                    // positionOfNewBodyPart[index].removeFromParent()
                    // positionOfNewBodyPart.remove(at: index)
                    //print(positionOfNewBodyPart.count)
                    
                    //            for bodyPart in playerBody {
                    //                bodyPart.removeFromParent()
                    //                playerLayer.addChild(bodyPart)
                    //                //print(bodyPart)
                    //                }
                    
                    movePlayer()
                    
                    
                    collectablePart.removeFromParent()
                    
                    
                    
                }
            }
        }
        
        
        else if player.playerDirection == "right"{
            if delta.x == -47 {
                if delta.y == 0 {
                    
                    magic?.position = positionOfHead
                    //magic?.alpha = 0.2
                    //              let partForAppending: SKSpriteNode
                    //
                    //                if(newBlockColor == 1)
                    //                {
                    //                    partForAppending = SKSpriteNode(imageNamed : "RedBlock")
                    //                }
                    //                else if(newBlockColor == 2){
                    //                    partForAppending = SKSpriteNode(imageNamed : "OrangeBlock")}
                    //                else if(newBlockColor == 3){
                    //                    partForAppending = SKSpriteNode(imageNamed : "YellowBlock")}
                    //                else if(newBlockColor == 4){
                    //                    partForAppending = SKSpriteNode(imageNamed : "GreenBlock")}
                    //                else if(newBlockColor == 5){
                    //                    partForAppending = SKSpriteNode(imageNamed : "BlueBlock")}
                    //                else if(newBlockColor == 6){
                    //                    partForAppending = SKSpriteNode(imageNamed : "PurpleBlock")}
                    //                else{
                    //                    partForAppending = SKSpriteNode(imageNamed : "IndigoBlock")}
                    //
                    //
                    //
                    //
                    //                partForAppending.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
                    //          //  print(playerBody.count)
                    //                partForAppending.position = collectablePart.position
                    //print(collectablePart)
                    
                    let partForAppending = SKSpriteNode()
                    partForAppending.texture = collectablePart.texture
                    partForAppending.position = collectablePart.position
                    partForAppending.size = collectablePart.size
                    partForAppending.name = collectablePart.name
                    
                    playerBody.insert(partForAppending, at: 0)
                    playerLayer.addChild(partForAppending)
                    
                    partsToBeRemoved?.append(collectablePart)
                    
                    scoreNumber = scoreNumber + 1
                    
                    // positionOfNewBodyPart[index].removeFromParent()
                    // positionOfNewBodyPart.remove(at: index)
                    //print(positionOfNewBodyPart.count)
                    
                    //            for bodyPart in playerBody {
                    //                bodyPart.removeFromParent()
                    //                playerLayer.addChild(bodyPart)
                    //                //print(bodyPart)
                    //                }
                    
                    movePlayer()
                    
                    
                    collectablePart.removeFromParent()
                    
                    
                    
                }
            }
        }
        }
        
        
        for remove in partsToBeRemoved!
        {
            positionOfNewBodyPart.remove(at: positionOfNewBodyPart.index(of: remove)!)
        }
    }
    
    
    
    fileprivate func killPlayerIfNeeded() {
        
        //threeInARow()
        //sandwiches()
        if isPlayerRunOverItself {
            
           // print("DELETETETTE")
            removePlayerFromScreen()
            reset()
            
            
        }
    }
    
    private func removePlayerFromScreen() {
//        movePlayer()
//        movePlayer()
        for bodyPart in playerBody {
            bodyPart.removeFromParent()
        }
        playerBody.removeAll()
        player.playerBodyPartsRow.removeAll()
        player.playerBodyPartsColumn.removeAll()
        
       
        
        print(playerBody)
        
        
    }
    
    private func threeInARow(){
        if(playerBody.count > 2)
        {
            if(playerBody[0].name == playerBody[1].name)
            {
                if(playerBody[1].name == playerBody[2].name)
                {
                    //movePlayer()
                    print("remove bro")
                    
                    scoreNumber = scoreNumber + 10
                    //print(playerBody[0].name! + playerBody[1].name! + playerBody[2].name! )
                    //let newPosition: CGPoint = playerBody[3].position
                    player.playerBodyPartsColumn[3] = player.playerBodyPartsColumn[3]
                    player.playerBodyPartsRow[3] = player.playerBodyPartsRow[3]
                    for _ in 0...2 {
                        playerBody[0].removeFromParent()
                        playerBody.remove(at: 0)
                        //print(bodyPart)
                        player.playerBodyPartsRow.remove(at: 0)
                        player.playerBodyPartsColumn.remove(at: 0)
                    }
                   // movePlayer()
                    //playerBody[0].position = newPosition
                }
            }
        }
        
    }
    private func sandwiches(){
        if(playerBody.count > 2)
        {
        if(playerBody[0].name == playerBody[2].name)
            {
                //movePlayer()
                print("remove bro")
                
                scoreNumber = scoreNumber + 10
                //print(playerBody[0].name! + playerBody[1].name! + playerBody[2].name! )
                //player.playerBodyPartsColumn[3] = player.playerBodyPartsColumn[3]
                //player.playerBodyPartsRow[3] = player.playerBodyPartsRow[3]
                for _ in 0...2 {
                    playerBody[0].removeFromParent()
                    playerBody.remove(at: 0)
                    //print(bodyPart)
                    player.playerBodyPartsRow.remove(at: 0)
                    player.playerBodyPartsColumn.remove(at: 0)
                }
               // movePlayer()
               // playerBody[0].position = newPosition
            
            }
        }
        
    }
    
    private var isPlayerRunOverItself: Bool {
        var playerBodyPositions: [CGPoint] = []
        
        for intersect in 0..<player.playerBodyPartsColumn.count{
            playerBodyPositions.append(pointFor(column:player.playerBodyPartsColumn[intersect], row: player.playerBodyPartsRow[intersect]))
          //  print(intersect)
        }
        
        for position in playerBodyPositions {
            let filteredPositions = playerBodyPositions.filter({ (examinedPoint) -> Bool in
                return examinedPoint.x == position.x && examinedPoint.y == position.y
            })
            
             //print("This is filtered positions\(filteredPositions)")
            
            if filteredPositions.count > 1 {
                print("COllISION")
                return true
            }
        }
        return false
    }
    
    private var playerReachedScreenBounds : Bool {
        let positionOfHead = playerBody[0].position
        
        let leftBound   = -size.width / 2 // because anchor point is in center, same for the rest bounds
        if positionOfHead.x <= leftBound    { return true }
        
        let rightBound  = +size.width / 2
        if positionOfHead.x >= rightBound   { return true }
        
        let topBound    = +size.height / 2
        if positionOfHead.y >= topBound     { return true }
        
        let bottomBound = -size.height / 2
        if positionOfHead.y <= bottomBound  { return true }
        
        return false
    }
    
    func reset(){
        player = Player(column: 7, row: 13)
        
        playerSprite.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
        playerSprite.position = pointFor(column: 7, row: 13)
        player.sprite = playerSprite
        
        let bodyPart = SKSpriteNode(imageNamed : "RedOrb")
        let bodyPart2 = SKSpriteNode(imageNamed : "OrangeOrb")
        let bodyPart3 = SKSpriteNode(imageNamed : "YellowOrb")
        let bodyPart4 = SKSpriteNode(imageNamed : "GreenOrb")
        let bodyPart5 = SKSpriteNode(imageNamed : "BlueOrb")
        let bodyPart6 = SKSpriteNode(imageNamed : "IndigoOrb")
        let bodyPart7 = SKSpriteNode(imageNamed : "PurpleOrb")
        
        //GLOW
        //bodyPart.addGlow(radius: glowRadius)
        
        bodyPart.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart.name = "Red"
        bodyPart2.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart2.name = "Orange"
        bodyPart3.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart3.name = "Yellow"
        bodyPart4.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart4.name = "Green"
        bodyPart5.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart5.name = "Blue"
        bodyPart6.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart6.name = "Indigo"
        bodyPart7.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart7.name = "Purple"
        
        playerBody = [bodyPart, bodyPart2, bodyPart3, bodyPart4, bodyPart5, bodyPart6, bodyPart7]
        
        for bodyPart in playerBody {
            bodyPart.removeFromParent()
            playerLayer.addChild(bodyPart)
            //print(bodyPart)
        }
        
        scoreNumber = 0

        
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
    
    /**func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        print("touches began")
        let touch = touches.anyObject() as! UITouch
        let positionInScene = touch.location(in: blocksLayer)
        
        selectNodeForTouch(touchLocation: positionInScene)
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        /*if let touch = touches.first {
            let positionInScene = touch.location(in: scene!)
           // print("touches began works")
            
            selectNodeForTouch(touchLocation: positionInScene)
        }
        super.touchesBegan(touches, with: event)*/
        
        print("touches began")
        
        let touch = touches.first // get the first touch
        selectNodeForTouch(touchLocation: (touch?.location(in: self))!)
        
       /* if(touchedNode == pauseButton)
        {
            self.scene?.view?.isPaused = true
        }*/
        
    
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
            
            /*if (touchedNode?.isEqual(pauseButton))!{
                
                print("PAUSE")
                self.scene?.view?.isPaused = true
            }*/
            
            if(touchedNode?.name != nil)
            {
            if touchedNode?.name! == pauseButton.name {
                print("PAUSE WORKING")
                
                if(self.scene?.view?.isPaused == false)
                {
                    self.scene?.view?.isPaused = true
                    GameScene.gameIsPaused = true
                }
                    
                else if(self.scene?.view?.isPaused == true)
                {
                    self.scene?.view?.isPaused = false
                    GameScene.gameIsPaused = false
                }
                /*let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(degree: -10.0), duration: 0.1),
                 SKAction.rotate(byAngle: 0.0, duration: 0.1),
                 SKAction.rotate(byAngle: degToRad(degree: 10.0), duration: 0.1)])
                 selectedNode.run(SKAction.repeatForever(sequence))*/
                
            }
            }

            /*if !selectedNode.isEqual(touchedNode){
                print("same sprite")
                //self.scene?.view?.isPaused = true
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))

                selectedNode = touchedNode as! SKSpriteNode
                
                if !selectedNode.isEqual(pauseButton){
                    print("PRESSED PAUSE")
                    
                    if(self.scene?.view?.isPaused == false)
                    {
                        self.scene?.view?.isPaused = true
                    }
                    
                    else if(self.scene?.view?.isPaused == true)
                    {
                        self.scene?.view?.isPaused = false
                    }
                }
                
            }*/
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
        //print("touches MOVED")
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
        //NSLog("counting... \(g)")
        
        //g = g+1
        
        if(GameScene.gameIsPaused == false)
        {
        
            if (player.row + player.ySpeed >= 1) && (player.row + player.ySpeed <= NumRows-2)
            {
                player.row = player.row + player.ySpeed
            }
        
            if (player.column + player.xSpeed >= 1) && (player.column + player.xSpeed <= NumColumns-2)
            {
                player.column = player.column + player.xSpeed
            }
        
       // updatePlayer()
            
            //bodyPart.addGlow(radius: glowRadius)
            glowRadius+=2.0
        
        killPlayerIfNeeded()
        growSnakeIfNeeded()
        movePlayer()
        threeInARow()
        sandwiches()
        updatePositionOfBodyParts()
        putNewBodyPartIfNeeded()
        
        //UPDATE SCORE
        
            score.text = (String)(describing: scoreNumber)
            
        }
        
    }
    

}


