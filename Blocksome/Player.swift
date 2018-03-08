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
    
    init(column: Int, row: Int)
    {
        self.column = column
        self.row = row
        
        self.playerWidth = 26.00
        self.playerHeight = 26.25
        
        self.xSpeed = 0
        self.ySpeed = 1
        
        self.sprite = SKSpriteNode(imageNamed: "Cupcake")
        
    }
    
    init()
    {
        self.column = 0
        self.row = 0
        
        self.playerWidth = 26.00
        self.playerHeight = 26.25
        
        self.xSpeed = 0
        self.ySpeed = 1
        
        self.sprite = SKSpriteNode(imageNamed: "Cupcake")
    }
    
    var hashValue: Int {
        return row*10 + column
    }

}



