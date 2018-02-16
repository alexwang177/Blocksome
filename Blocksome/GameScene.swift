//
//  GameScene.swift
//  Blocksome
//
//  Created by AlexWang1 on 1/30/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import SpriteKit
import GameplayKit

private let kBlockNodeName = "movable"

class GameScene: SKScene {
    
    var level: Level!
    
    let TileWidth: CGFloat = 60.0     //32.0
    let TileHeight: CGFloat = 60.0    //36.0
    
    let gameLayer = SKNode()
    let blocksLayer = SKNode()
    let tilesLayer = SKNode()
    
    var selectedNode = SKSpriteNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
   // backgroundColor = SKColor.red
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        /*let background = SKSpriteNode(imageNamed: "Background")
        
        background.size = size
        addChild(background)*/
        
        
        // Add a new node that is the container for all other layers on the playing
        // field. This gameLayer is also centered in the screen.
        addChild(gameLayer)
        
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
                }
                else{
                    print("Empty tile lolz")
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
        
        self.backgroundColor = UIColor.blue
    }
    
    // Sprite Touch Selection
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        print("touches began")
        let touch = touches.anyObject() as! UITouch
        let positionInScene = touch.location(in: self)        //*******
        
        selectNodeForTouch(touchLocation: positionInScene)
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree)/180.0 * Double.pi)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint)
    {
        print("touch")
        let touchedNode = self.atPoint(touchLocation)       //*******
        
        if touchedNode is SKSpriteNode{
            print("is a sprite")
            
            if !selectedNode.isEqual(touchedNode){
                print("same sprite")
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                
                if touchedNode.name! == kBlockNodeName {
                    print("wiggle")
                    let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(degree: -4.0), duration: 0.1),
                                                      SKAction.rotate(byAngle: 0.0, duration: 0.1),
                                                      SKAction.rotate(byAngle: degToRad(degree: 4.0), duration: 0.1)])
                    selectedNode.run(SKAction.repeatForever(sequence))
                    
                }
            }
        }
        
    }
    
    

}
