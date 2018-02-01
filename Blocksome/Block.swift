//
//  Block.swift
//  Blocksome
//
//  Created by AlexWang1 on 2/1/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import SpriteKit

enum BlockType: Int {
    case unknown = 0, croissant, cupcake, danish, donut, macaroon , sugarCookie
}

class Block{
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
