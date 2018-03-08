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
    
    var playerDirection: String
    
    
    
    var playerBodyPartsColumn: [Int]
    var playerBodyPartsRow: [Int]
    
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int)
    {
        self.column = column
        self.row = row
        
        self.playerWidth = 26.00
        self.playerHeight = 26.25
        
        self.xSpeed = 0
        self.ySpeed = 1
        
        playerDirection = "up"
        
        
        playerBodyPartsColumn = [column]
        playerBodyPartsRow = [row]
        
        
        self.sprite = SKSpriteNode(imageNamed: "Cupcake")
        
    }
    
    var hashValue: Int {
        return row*10 + column
    }

}

enum SnakeDirection: UInt16 {
    case up     = 0x7E
    case down   = 0x7D
    case left     = 0x7B
    case right     = 0x7C
}

extension CGSize {
    static var snakeSize: CGSize { return CGSize(width: 25, height: 25) }
}

extension SKSpriteNode {
    static var snakeBodyPart: SKSpriteNode {
        let bodyPart = SKSpriteNode(color: .green, size: .snakeSize)
        return bodyPart
    }
    
    static var snakeNewBodyPart: SKSpriteNode {
        let bodyPart = SKSpriteNode(color: .red, size: .snakeSize)
        return bodyPart
    }
}

extension CGPoint {
    static var normalizedMiddle: CGPoint { return CGPoint(x: 0.5, y: 0.5) }
    
    func offsetBy(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: x + point.x, y: y + point.y)
    }
    
    var pointToLeft: CGPoint {
        return self.offsetBy(CGPoint(x:-CGSize.snakeSize.width, y: 0))
    }
    
    var pointToRight: CGPoint {
        return self.offsetBy(CGPoint(x:CGSize.snakeSize.width, y: 0))
    }
    
    var pointToUp: CGPoint {
        return self.offsetBy(CGPoint(x:0, y: CGSize.snakeSize.height))
    }
    
    var pointToDown: CGPoint {
        return self.offsetBy(CGPoint(x:0, y: -CGSize.snakeSize.height))
    }
}



