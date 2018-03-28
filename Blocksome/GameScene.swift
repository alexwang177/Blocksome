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
    
    let TileWidth: CGFloat = 47//26.00
    let TileHeight: CGFloat = 47.75//26.25
    
    let background = SKSpriteNode(imageNamed: "BackgroundBlue")
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    let blocksLayer = SKNode()
    
    let playerLayer = SKNode()
    
    var playerSprite = SKSpriteNode()
    
    var _possiblePositionsForNewBodyParts: [CGPoint]?
    
    var positionOfNewBodyPart: CGPoint?
    
    var newBlockColor: Int?
    
    var obstacle = SKSpriteNode()

    var selectedNode = SKSpriteNode()
    
    let bodyPart = SKSpriteNode(imageNamed : "RedBlock")
    let bodyPart2 = SKSpriteNode(imageNamed : "OrangeBlock")
    let bodyPart3 = SKSpriteNode(imageNamed : "YellowBlock")
    let bodyPart4 = SKSpriteNode(imageNamed : "Tile")
    let bodyPart5 = SKSpriteNode(imageNamed : "Tile")
    let bodyPart6 = SKSpriteNode(imageNamed : "Tile")
    
    var playerBody: [SKSpriteNode]!
    
   /*required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
        //super.init(coder: aDecoder)
       //setup()
        
    }*/
    
    override func didMove(to view: SKView) {
        
        scheduledTimerWithTimerInterval()
        
        physicsWorld.contactDelegate = self
        
        self.player = Player(column: 10, row: 10)
        
        self.playerBody = [bodyPart, bodyPart2, bodyPart3, bodyPart4, bodyPart5, bodyPart6, bodyPart7]
        
        //self.player = Player(column: 10, row: 10)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        playerSprite = SKSpriteNode(imageNamed: "Tile")
        
        
        
        self.background.name = "background"
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.size = self.size
        self.addChild(background)
        
        //Block Sizes
        bodyPart.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart2.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart3.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart4.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart5.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart6.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        bodyPart7.size = CGSize(width: player.playerWidth, height: player.playerHeight)
        
        
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
        
        playerLayer.addChild(obstacle)
        
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
        
        playerSprite.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
        playerSprite.position = pointFor(column: player.column, row: player.row)
        player.sprite = playerSprite
        
        
       // let playerBodyPartsContainer = SKNode()
        //playerBodyPartsContainer.name = "playerBodyPartsContainer"
        
      //addChild(playerBodyPartsContainer)
        
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
            if(headPositionRow + 1 <= NumRows-2)
            {
            player.playerBodyPartsRow.insert(headPositionRow + 1, at: 0)
            player.playerBodyPartsColumn.insert(headPositionColumn, at: 0)
            }
        case "down":
            if(headPositionRow - 1 >= 1)
            {
            player.playerBodyPartsRow.insert(headPositionRow - 1, at: 0)
            player.playerBodyPartsColumn.insert(headPositionColumn, at: 0)
            }
        case "left":
            if(headPositionColumn + 1 >= 3)
            {
            player.playerBodyPartsColumn.insert(headPositionColumn - 1, at: 0)
            player.playerBodyPartsRow.insert(headPositionRow , at: 0)
            }
        case "right":
            if(headPositionColumn - 1 <= NumColumns - 4)
            {
            player.playerBodyPartsColumn.insert(headPositionColumn + 1, at: 0)
            player.playerBodyPartsRow.insert(headPositionRow , at: 0)
            }
        default:
            print("There has been a fatal error in move player regarding playerDirection")
        }
//        for bodyPart in playerBody {
//            print("REEEEEAALLLL BODYYY BRO \(bodyPart)")
//        }
    }
    
    func updatePositionOfBodyParts(){
        for i in 0..<player.playerBodyPartsColumn.count{
            if i < playerBody.count{
                //  print("PLAYERCOLUMN - \(i) :  \(player.playerBodyPartsRow[i])")
                //print("PLAYERBODY  -  \(i) :  \(playerBody[i].position)")
                let bodyPart = playerBody[i]
                bodyPart.position = pointFor(column: player.playerBodyPartsColumn[i], row: player.playerBodyPartsRow[i])
                //print("BODY  -  \(i) :  \(bodyPart.position)")
                
                playerBody[i].position = bodyPart.position
                
               // print("Head Row: \(player.playerBodyPartsRow[0])   Head Column: \(player.playerBodyPartsColumn[0]) ")
              //  print("Head Position: \(pointFor(column: player.playerBodyPartsColumn[0], row: player.playerBodyPartsRow[0]))")
            }
                
            else{
                player.playerBodyPartsColumn.removeLast()
                player.playerBodyPartsRow.removeLast()
            }
        }
        
        //print("LKJDFLKSDJFLSDFJSDLKJSDF:SDLFJSD:LFKJ:SDKJF \(playerBody)")
    }
    
    
    fileprivate func putNewBodyPartIfNeeded() {
        guard childNode(withName: "//newBodyPart") == nil else { return }
        putNewBodyParts()
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
            newBodyPart = SKSpriteNode(imageNamed : "RedBlock")
        }
        else if(newBlockColor == 2){
            newBodyPart = SKSpriteNode(imageNamed : "OrangeBlock")}
        else if(newBlockColor == 3){
            newBodyPart = SKSpriteNode(imageNamed : "YellowBlock")}
        else if(newBlockColor == 4){
            newBodyPart = SKSpriteNode(imageNamed : "GreenBlock")}
        else if(newBlockColor == 5){
            newBodyPart = SKSpriteNode(imageNamed : "BlueBlock")}
        else if(newBlockColor == 6){
            newBodyPart = SKSpriteNode(imageNamed : "PurpleBlock")}
        else{
            newBodyPart = SKSpriteNode(imageNamed : "IndigoBlock")
            
        }
        
        newBodyPart.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
        newBodyPart.name = "newBodyPart"
        newBodyPart.position = randPosition
        
        positionOfNewBodyPart = newBodyPart.position
        
       // container.addChild(newBodyPart)
        playerLayer.addChild(newBodyPart)
        
        print("This is the new body part position: \(newBodyPart.position)")
    }
    
    fileprivate var positionsForNewBodyParts: [CGPoint] {
        
        if let alreadyCalculatedPositions = _possiblePositionsForNewBodyParts {
            return alreadyCalculatedPositions
        }
        
        var positions: [CGPoint] = []
        
    
        var isIntersect = false
        for row in 1...26{
            for column in 1...14{
                for intersect in 0..<playerBody.count{
                    if playerBody[intersect].position == pointFor(column: column, row: row){
                        isIntersect = true
                    }
                }
                
                if(isIntersect == false)
                {
                    positions.append(pointFor(column: column, row: row))
                }
                
                isIntersect = false
            }
        }
    
        _possiblePositionsForNewBodyParts = positions
        return positions
    }
    
    func growSnakeIfNeeded() {
//        guard let playerNew = childNode(withName: "playerBodyPartsContainer") else { return }
        let positionOfHead  = pointFor(column: player.playerBodyPartsColumn[0], row: player.playerBodyPartsRow[0])
        guard let collectablePart = childNode(withName: "//newBodyPart") else { return }
        
       // print(collectablePart.position)
//
//
//        let delta = CGPoint(x: abs(positionOfHead.x - collectablePart.position.x), y: abs(positionOfHead.y - collectablePart.position.y))
//        if delta.x < player.playerWidth / 2 {
//            if delta.y < player.playerHeight / 2 {
//                let partForAppending: SKSpriteNode = SKSpriteNode(imageNamed : "Tile")
//                playerNew.addChild(partForAppending)
//                playerBody.append(partForAppending)
//                collectablePart.removeFromParent()
//            }
//        }
        
        let delta = CGPoint(x: abs(positionOfHead.x - collectablePart.position.x), y: abs(positionOfHead.y - collectablePart.position.y))
        
       // print(delta)
                if delta.x < player.playerWidth / 2 {
                   if delta.y < player.playerHeight / 2 {
                    
                    print(positionOfHead.x - collectablePart.position.x)
        
        if(positionOfNewBodyPart == pointFor(column: player.playerBodyPartsColumn[0], row: player.playerBodyPartsRow[0]))
                {
                    
            
                    
                    let partForAppending: SKSpriteNode
                    
                    if(newBlockColor == 1)
                    {
                        partForAppending = SKSpriteNode(imageNamed : "RedBlock")
                    }
                    else if(newBlockColor == 2){
                        partForAppending = SKSpriteNode(imageNamed : "OrangeBlock")}
                    else if(newBlockColor == 3){
                        partForAppending = SKSpriteNode(imageNamed : "YellowBlock")}
                    else if(newBlockColor == 4){
                        partForAppending = SKSpriteNode(imageNamed : "GreenBlock")}
                    else if(newBlockColor == 5){
                        partForAppending = SKSpriteNode(imageNamed : "BlueBlock")}
                    else if(newBlockColor == 6){
                        partForAppending = SKSpriteNode(imageNamed : "PurpleBlock")}
                    else{
                        partForAppending = SKSpriteNode(imageNamed : "IndigoBlock")
                        
                    }

            
            partForAppending.size = CGSize(width: (player.playerWidth), height: player.playerHeight)
          //  print(playerBody.count)
            playerBody.insert(partForAppending, at: 0)
            collectablePart.removeFromParent()
            
            //print("CONTACT PLZ DO SOMETHING")
            //print(playerBody.count)
                }
                                                        }
                                                    }
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
        //NSLog("counting... \(g)")
        g = g+1
        
        if (player.row + player.ySpeed >= 1) && (player.row + player.ySpeed <= NumRows-2)
        {
            player.row = player.row + player.ySpeed
        }
        
        if (player.column + player.xSpeed >= 1) && (player.column + player.xSpeed <= NumColumns-2)
        {
            player.column = player.column + player.xSpeed
        }
        
       // print("\(player.ySpeed) is Y and \(player.xSpeed) is X")
        
        //playerLayer.removeAllChildren()
        
       // updatePlayer()
        
        
        updatePositionOfBodyParts()
        movePlayer()
        putNewBodyPartIfNeeded()
        growSnakeIfNeeded()
        
        for bodyPart in playerBody {
            bodyPart.removeFromParent()
            playerLayer.addChild(bodyPart)
            //print(bodyPart)
        }
        
    }
    

    
}

