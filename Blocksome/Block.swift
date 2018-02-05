//
//  Block.swift
//  Blocksome
//
//  Created by AlexWang1 on 2/1/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import SpriteKit

enum BlockType: Int, CustomStringConvertible {
    case unknown = 0, croissant, cupcake, danish, donut, macaroon , sugarCookie
    
    
    var spriteName: String{
        let spriteNames = [
        "Croissant",
        "Cupcake",
        "Danish",
        "Donut",
        "Macaroon",
        "Sugar Cookie"]
        
        return spriteNames[rawValue - 1]
    }
    
    var description: String{
        return spriteName
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> BlockType{
        return BlockType(rawValue: Int(arc4random_uniform(6))+1)!
    }
}

class Block: CustomStringConvertible{
    var description: String{
        return "type:\(blockType) square:(\(column),\(row))"
    }
    
    var column: Int
    var row: Int
    let blockType: BlockType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, blockType: BlockType)
    {
        self.column = column
        self.row = row
        self.blockType = blockType
    }
}
