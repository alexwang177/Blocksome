//
//  Player.swift
//  Blocksome
//
//  Created by AlexWang1 on 2/22/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import Foundation
import SpriteKit

class Player{
    
    var column: Int
    var row: Int
    
    var playerWidth: CGFloat
    var playerHeight: CGFloat
    
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int)
    {
        self.column = column
        self.row = row
        
        self.playerWidth = 26.00
        self.playerHeight = 26.25
        
        self.sprite = SKSpriteNode(imageNamed: "BlackImage")
        
    }
    
    var hashValue: Int {
        return row*10 + column
    }

}



