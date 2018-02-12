//
//  Block.swift
//  Blocksome
//
//  Created by AlexWang1 on 2/1/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import SpriteKit

enum BlockType: Int, CustomStringConvertible {
    case unknown = 0,stoneTile, woodTile
    
    
    var spriteName: String{
        let spriteNames = [
        "StoneTile",
        "WoodTile"]
        
        return spriteNames[rawValue - 1]
    }
    
    var description: String{
        return spriteName
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> BlockType{
        return BlockType(rawValue: Int(arc4random_uniform(2))+1)!
    }
}

func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

class Block: CustomStringConvertible, Hashable{
    
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
    
    var hashValue: Int {
        return row*10 + column
    }
    
    var description: String{
        return "type:\(blockType) square:(\(column),\(row))"
    }
}
