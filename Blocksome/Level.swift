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
    
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    func blockAt(column: Int, row: Int) -> Block? {
        assert(column>=0 && column<NumColumns)
        assert(row>=0 && row<NumRows)
        return blocks[column, row]
    }
    
    func tileAt(column: Int, row: Int) -> Tile? {
        assert(column>=0 && column<NumColumns)
        assert(row>=0 && row<NumRows)
        return tiles[column, row]
    }
    
    func shuffle() -> Set<Block> {
        return createInitialBlocks()
    }
    
    private func createInitialBlocks() -> Set<Block> {
        var set = Set<Block>()
        
        // 1
        for row in 0..<NumRows{
            for column in 0..<NumColumns{
                
                // new line
                if tiles[column, row] == nil{
                    // 2
                    var blockType = BlockType.random()
                    
                    // 3
                    let block = Block(column: column, row: row, blockType: blockType)
                    blocks[column,row] = block
                    
                    // 4
                    set.insert(block)
                }
            }
        }
        return set
    }
    
    init(filename: String) {
        // 1
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        // 2
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        // 3
        for (row, rowArray) in tilesArray.enumerated() {
            // 4
            let tileRow = NumRows - row - 1
            // 5
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
    }
    
/* Load the named file into a Dictionary using the loadJSONFromBundle(filename:) helper function that you just added. Note that this function may return nil -- it returns an optional -- and here you use a guard to handle this situation.
 
     The dictionary has an array named "tiles". This array contains one element for each row of the level. Each of those row elements is itself an array containing the columns for that row. The type of tilesArray is therefore array-of-array-of-Int, or [[Int]].
 
     Step through the rows using built-in enumerated() function, which is useful because it also returns the current row number.
 
     In Sprite Kit (0, 0) is at the bottom of the screen, so you have to reverse the order of the rows here. The first row you read from the JSON corresponds to the last row of the 2D grid.
 
     Step through the columns in the current row. Every time it finds a 1, it creates a Tile object and places it into the tiles array.*/
    
    
    

}
