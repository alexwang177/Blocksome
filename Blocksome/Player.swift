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
    
    var xSpeed: Int
    var ySpeed: Int
    
    var sprite: SKSpriteNode?
    var playerDirection: String
    
    var playerBodyPartsColumn: [Int]
    var playerBodyPartsRow: [Int]
    
    init(column: Int, row: Int)
    {
        self.column = column
        self.row = row
        
        self.playerWidth = 47
        self.playerHeight = 47.75
        
        self.xSpeed = 0
        self.ySpeed = 1
        playerDirection = "up"
        
        playerBodyPartsColumn = [column]
        playerBodyPartsRow = [row]

        
        self.sprite = SKSpriteNode(imageNamed: "RedBlock")
        
    }
    
    init()
    {
        self.column = 0
        self.row = 0
        
        self.playerWidth = 47
        self.playerHeight = 47.75
        
        self.xSpeed = 0
        self.ySpeed = 1
        
        playerDirection = "up"
        
        playerBodyPartsColumn = [column]
        playerBodyPartsRow = [row]
        
        self.sprite = SKSpriteNode(imageNamed: "RedBlock")
    }
    
    var hashValue: Int {
        return row*10 + column
    }

}



