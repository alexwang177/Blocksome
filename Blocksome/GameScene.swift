//
//  GameScene.swift
//  Blocksome
//
//  Created by AlexWang1 on 1/30/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    var level: Level!
    
    let TileWidth: CGFloat = 60.0     //32.0
    let TileHeight: CGFloat = 60.0    //36.0
    
    let gameLayer = SKNode()
    let blocksLayer = SKNode()
    let tilesLayer = SKNode() 
    
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
                    print("Empty tile lol")
                }
            }
        }
    }
    
    func addSprites(for blocks: Set<Block>){
        for block in blocks {
            // Create a new sprite for the cookie and add it to the cookiesLayer.
            let sprite = SKSpriteNode(imageNamed: block.blockType.spriteName)
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
    
    func convertPoint(toView point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else{
            return (false, 0, 0)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1
        guard let touch = touches.first else{return}
        let location = touch.location(in: blocksLayer)
        //2
        let(success, column, row) = convertPoint(toView: location)
        if success{
            //3
            if let block = level.blockAt(column: column, row: row){
                //4
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard swipeFromColumn != nil else{return}
        
        guard let touch = touches.first else{return}
        let location = touch.location(in: blocksLayer)
        
        let (success, column, row) = convertPoint(toView: location)
        if success {
            var horzDelta = 0, vertData = 0
            if column < swipeFromColumn!{
                horzDelta = -1
            } else if column > swipeFromColumn! {
                horzDelta = 1
            } else if row < swipeFromRow!{
                vertData = -1
            } else if row > swipeFromRow!{
                vertData = 1
            }
            
            if horzDelta != 0 || vertData != 0 {
                trySwap(horizontal: horzDelta, vertical: vertData)
                
                swipeFromColumn = nil
            }
        }
        
        
    }
    
    func trySwap(horizontal horzDelta: Int, vertical vertDelta: Int){
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        
        guard toColumn >= 0 && toColumn < NumColumns else{return}
        guard toRow >= 0 && toRow < NumRows else{return}
        
        if let toBlock = level.blockAt(column: toColumn, row: toRow),
            let fromBlock = level.blockAt(column: swipeFromColumn!, row: swipeFromRow!){
            print("***swapping \(fromBlock) with \(toBlock)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromRow = nil
        swipeFromColumn = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.blue
    }
    

}
