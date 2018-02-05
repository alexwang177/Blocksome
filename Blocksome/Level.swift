//
//  Level.swift
//  Blocksome
//
//  Created by AlexWang1 on 2/5/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

class Level {
    fileprivate var blocks = Array2D<Block>(columns: NumColumns, rows: NumRows)
    
    func blockAt(column: Int, row: Int) -> Block? {
        assert(column>=0 && column<NumColumns)
        assert(row>=0 && row<NumRows)
        return blocks[column, row]
    }
    
    func shuffle() -> Set<Block> {
        return createInitialBlocks()
    }
    
    private func createInitialBlocks() -> Set<Block> {
        var set = Set<Block>()
        
        // 1
        for row in 0..<NumRows{
            for column in 0..<NumColumns{
                
                // 2
                var blockType = BlockType.random()
                
                // 3
                let block = Block(column: column, row: row, blockType: blockType)
                blocks[column,row] = block
                
                // 4
                set.insert(block)
            }
        }
        return set
    }
}
