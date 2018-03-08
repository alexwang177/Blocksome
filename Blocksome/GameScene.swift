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

class GameScene: SKScene {
    
    var g: Int = 1
    
    var player: Player {
        willSet(newValue){
            
        }
        didSet(oldValue){
    
        }
    }
    
    var level: Level!
    
    //let TileWidth: CGFloat = (CGFloat)((Int)(screenWidth)/NumColumns)    //34.0
    //let TileHeight: CGFloat = (CGFloat)((Int)(screenHeight)/NumRows) //36.0
    
    let TileWidth: CGFloat = 26.00   //34.0
    let TileHeight: CGFloat = 26.25
    
    let background = SKSpriteNode(imageNamed: "BackgroundBlue")
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    let blocksLayer = SKNode()
    
    let playerLayer = SKNode()
    
    let bodyPart = SKSpriteNode(imageNamed : "Tile")
    

    var selectedNode = SKSpriteNode()
    
    var currentDirection: SnakeDirection = .right
    var snakeBody: [SKSpriteNode] = [.snakeBodyPart, .snakeBodyPart, .snakeBodyPart, .snakeBodyPart]
    var snakeBodyPartsPositions: [CGPoint] = [.zero]
    
    var playerBody: [SKSpriteNode]
    
    var oldUpdateTime: TimeInterval = 0
    
    var _possiblePositionsForNewBodyParts: [CGPoint]?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
   // backgroundColor = SKColor.red
    
    override init(size: CGSize) {
        
        self.player = Player(column: 10, row: 10)
        self.playerBody = [bodyPart, bodyPart, bodyPart]
        super.init(size: size)
        
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //background = SKSpriteNode(imageNamed: "BackgroundBlue")
        
        self.background.name = "background"
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.size = size
        addChild(background)
        
        // Add a new node that is the container for all other layers on the playing
        // field. This gameLayer is also centered in the screen.
        addChild(gameLayer)
        
       // self.playerBody = [bodyPart, bodyPart, bodyPart]
        
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
    
    func prepareScene() {
        self.anchorPoint = .normalizedMiddle
        let snakeBodyPartsContainer = SKNode()
        snakeBodyPartsContainer.name = "snakeBodyPartsContainer"
        addChild(snakeBodyPartsContainer)
        for bodyPart in snakeBody {
            snakeBodyPartsContainer.addChild(bodyPart)
        }
        
        let newBodyPartsContainer = SKNode()
        newBodyPartsContainer.name = "newBodyPartsContainer"
        addChild(newBodyPartsContainer)
    }
    
    // LEVEL SETUP
    func addTiles(){
        for row in 0..<NumRows{
            for column in 0..<NumColumns {
                // If there is a tile at this position, then create a new tile
                // sprite and add it to the mask layer.
                if level.tileAt(column: column, row: row) != nil{
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
    
   
    
    // MARK: Point conversion
    
    // Converts a column,row pair into a CGPoint that is relative to the cookieLayer.
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2
        )
    }
    
    override func didMove(to view: SKView) {
        
        //self.backgroundColor = UIColor.blue
        scheduledTimerWithTimerInterval()
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
        
        if selectedNode.name! == kBlockNodeName {
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
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
     //LOL SORRY WHAT IS THIS CHEESE CUH
    @objc func updateCounting()
    {
        //NSLog("counting... \(g)")
        g = g+1
        
        player.row = player.row + 1
        
        //addPlayer()
      //  movePlayer()
        //killPlayerIfNeeded()
    
    }
 
 
    
    func addPlayer()
    {
        player = Player(column: player.column, row: player.row)
        
        
        
        let playerBodyPartsContainer = SKNode()
        playerBodyPartsContainer.name = "snakeBodyPartsContainer"
        
        addChild(playerBodyPartsContainer)
        
        for bodyPart in playerBody {
            bodyPart.removeFromParent()
            playerLayer.addChild(bodyPart)
        }
        
        let newBodyPartsContainer = SKNode()
        newBodyPartsContainer.name = "newBodyPartsContainer"
        addChild(newBodyPartsContainer)


        //SKETCHY CODE
//        let sprite = SKSpriteNode(imageNamed: "Tile")
//
//        sprite.size = CGSize(width: player.playerWidth, height: player.playerHeight)
//        sprite.position = pointFor(column: player.column, row: player.row)
//        playerLayer.addChild(sprite)
//        player.sprite = sprite
//
//        print("ADDED PLAYER")
    }
    
    func movePlayer(){
        guard let headPositionColumn = player.playerBodyPartsColumn.first else{return}
        
        guard let headPositionRow = player.playerBodyPartsRow.first else{return}
        
        switch player.playerDirection{
        case "up":
            player.playerBodyPartsRow.insert(headPositionRow + 1, at: 0)
        case "down":
            player.playerBodyPartsRow.insert(headPositionRow - 1, at: 0)
        case "left":
            player.playerBodyPartsColumn.insert(headPositionColumn - 1, at: 0)
        case "right":
            player.playerBodyPartsColumn.insert(headPositionColumn + 1, at: 0)
        default:
            print("There has been a fatal error in move player regarding playerDirection")
        }
    }
    
    func updatePositionOfBodyParts(){
        for i in 0..<player.playerBodyPartsColumn.count{
            if i < playerBody.count{
                let bodyPart = playerBody[i]
                bodyPart.position = pointFor(column: player.playerBodyPartsColumn[i], row: player.playerBodyPartsRow[i])
            }
            else{
                player.playerBodyPartsColumn.removeLast()
                player.playerBodyPartsRow.removeLast()
            }
        }
    }
    
    
    func killPlayerIfNeeded() {
        if isSnakeRunOverItself || snakeReachedScreenBounds {
            removeSnakeFromScreen()
            reset()
            
            
        }
    }
    
    private func removePlayerFromScreen() {
        guard let snake = childNode(withName: "snakeBodyPartsContainer") else { return }
        snake.removeFromParent()
        snakeBody.removeAll()
        
        
    }
    
    private var isPlayerRunOverItself: Bool {
        for position in snakeBodyPartsPositions {
            let filteredPositions = snakeBodyPartsPositions.filter({ (examinedPoint) -> Bool in
                return examinedPoint.x == position.x && examinedPoint.y == position.y
            })
            
            // print("This is filtered positions\(filteredPositions)")
            
            if filteredPositions.count > 1 {
                return true
            }
        }
        return false
    }
    
    private var playerReachedScreenBounds : Bool {
        guard let positionOfHead = snakeBodyPartsPositions.first else { return true }
        
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
    
}













//MARK: Main Loop

extension GameScene {
    
//    override func update(_ currentTime: TimeInterval) {
//        //print("WHy r u running!")
//        let delta: TimeInterval = 0.25
//        if currentTime - oldUpdateTime > delta {
//            oldUpdateTime = currentTime
//            killSnakeIfNeeded()
//            growSnakeIfNeeded()
//            moveSnake()
//            updatePositionsOfBodyParts()
//            putNewBodyPartIfNeeded()
//        }
//    }
    
        override func update(_ currentTime: TimeInterval) {
            //print("WHy r u running!")
            let delta: TimeInterval = 0.5
            if currentTime - oldUpdateTime > delta {
                print("Current Time: \(currentTime)")
                print("Old Time: \(oldUpdateTime)")
                print("Subtracted Time: \(currentTime-oldUpdateTime)")
                oldUpdateTime = currentTime
                movePlayer()
                updatePositionOfBodyParts()
            }
        }
}

//MARK: - Grow Snake

extension GameScene {
    func growSnakeIfNeeded() {
        guard let snake = childNode(withName: "snakeBodyPartsContainer") else { return }
        guard let positionOfHead  = snakeBodyPartsPositions.first else { return }
        guard let collectablePart = childNode(withName: "//newBodyPart") else { return }
        
        
        let delta = CGPoint(x: abs(positionOfHead.x - collectablePart.position.x), y: abs(positionOfHead.y - collectablePart.position.y))
        if delta.x < CGSize.snakeSize.width / 2 {
            if delta.y < CGSize.snakeSize.height / 2 {
                let partForAppending: SKSpriteNode = .snakeBodyPart
                snake.addChild(partForAppending)
                snakeBody.append(partForAppending)
                collectablePart.removeFromParent()
            }
        }
    }
}

//MARK: - New Body Parts

extension GameScene {
    
    fileprivate func putNewBodyPartIfNeeded() {
        guard childNode(withName: "//newBodyPart") == nil else { return }
        putNewBodyParts()
    }
    
    private func putNewBodyParts() {
        
        guard let container = childNode(withName: "newBodyPartsContainer") else { return }
        
        let possiblePositions = positionsForNewBodyParts
        let randPositionIndex = arc4random_uniform(UInt32(possiblePositions.count))
        let randPosition = possiblePositions[Int(randPositionIndex)]
        
        let newBodyPart: SKSpriteNode = .snakeNewBodyPart
        newBodyPart.name = "newBodyPart"
        newBodyPart.position = randPosition
        container.addChild(newBodyPart)
    }
    
    fileprivate var positionsForNewBodyParts: [CGPoint] {
        
        if let alreadyCalculatedPositions = _possiblePositionsForNewBodyParts {
            return alreadyCalculatedPositions
        }
        
        var positions: [CGPoint] = []
        
        var xCoord: CGFloat = 0
        var yCoord: CGFloat = 0
        
        let lowerRightCorner = CGPoint(x: -size.width / 2, y: -size.height / 2)
        
        while lowerRightCorner.x + xCoord < size.width / 2 {
            
            while lowerRightCorner.y + yCoord < size.height / 2 {
                positions.append(CGPoint(x: lowerRightCorner.x + xCoord, y: lowerRightCorner.y + yCoord))
                yCoord += CGSize.snakeSize.height
            }
            yCoord = 0
            xCoord += CGSize.snakeSize.width
        }
        
        _possiblePositionsForNewBodyParts = positions
        return positions
    }
}

//MARK: - Game Over

extension GameScene {
    
    fileprivate func killSnakeIfNeeded() {
        if isSnakeRunOverItself || snakeReachedScreenBounds {
            removeSnakeFromScreen()
            reset()
            
            
        }
    }
    
    private func removeSnakeFromScreen() {
        guard let snake = childNode(withName: "snakeBodyPartsContainer") else { return }
        snake.removeFromParent()
        snakeBody.removeAll()
        
        
    }
    
    private var isSnakeRunOverItself: Bool {
        for position in snakeBodyPartsPositions {
            let filteredPositions = snakeBodyPartsPositions.filter({ (examinedPoint) -> Bool in
                return examinedPoint.x == position.x && examinedPoint.y == position.y
            })
            
            // print("This is filtered positions\(filteredPositions)")
            
            if filteredPositions.count > 1 {
                return true
            }
        }
        return false
    }
    
    private var snakeReachedScreenBounds : Bool {
        guard let positionOfHead = snakeBodyPartsPositions.first else { return true }
        
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
}

//MARK: - Player's Input

extension GameScene {
    
//    override func keyDown(with event: ) {
//        switch event.keyCode {
//        case SnakeDirection.up.rawValue:    currentDirection = currentDirection != .down    ? .up    : .down
//        case SnakeDirection.down.rawValue:  currentDirection = currentDirection != .up      ? .down  : .up
//        case SnakeDirection.left.rawValue:  currentDirection = currentDirection != .right   ? .left  : .right
//        case SnakeDirection.right.rawValue: currentDirection = currentDirection != .left    ? .right : .left
//        default: break
//        }
//    }
}

//MARK: Snake Movement
extension GameScene {
    
    fileprivate func updatePositionsOfBodyParts() {
        for i in 0..<snakeBodyPartsPositions.count {
            if i < snakeBody.count {
                let bodyPart = snakeBody[i]
                bodyPart.position = snakeBodyPartsPositions[i]
            } else { snakeBodyPartsPositions.removeLast() }
        }
    }
    
    fileprivate func moveSnake() {
        guard let headPosition = snakeBodyPartsPositions.first else { return }
        switch currentDirection {
        case .up:
            snakeBodyPartsPositions.insert(headPosition.pointToUp, at: 0)
        case .down:
            snakeBodyPartsPositions.insert(headPosition.pointToDown, at: 0)
        case .left:
            snakeBodyPartsPositions.insert(headPosition.pointToLeft, at: 0)
        case .right:
            snakeBodyPartsPositions.insert(headPosition.pointToRight, at: 0)
        }
    }
}

extension GameScene {
    
    fileprivate func reset(){
        currentDirection = .right
        snakeBody = [.snakeBodyPart, .snakeBodyPart, .snakeBodyPart, .snakeBodyPart]
        snakeBodyPartsPositions = [.zero]
        
        
        sceneDidLoad()
        
        for position in snakeBodyPartsPositions {
            print(position)
            print(snakeBodyPartsPositions.count)
        }
        
        
        
    }
    
}


