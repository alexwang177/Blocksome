//
//  Level.swift
//  Blocksome
//
//  Created by AlexWang1 on 2/5/18.
//  Copyright © 2018 Alex Wang. All rights reserved.
//
import Foundation
import UIKit

let NumColumns = 16
let NumRows = 28

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class Level {
    
// The 2D array that keeps track of where the Blocks are.
    fileprivate var blocks = Array2D<Block>(columns: NumColumns, rows: NumRows)
    
      // The 2D array that contains the layout of the level.
    fileprivate var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    // MARK: Initialization
    
    // Create a level by loading it from a file.
    init(filename: String){
        
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename)
            else {return}
        // The dictionary contains an array named "tiles". This array contains
        // one element for each row of the level. Each of those row elements in
        // turn is also an array describing the columns in that row. If a column
        // is 1, it means there is a tile at that location, 0 means there is not.
        
        //let score = dictionary["targetScore"] as! Int
        //print("Score: \(score)")
        
        guard let tilesArray = dictionary["tiles"] as? [[Int]]
        else{
            print("Still failing")
            return
        }
    
        // Loop through the rows...
        for (row, rowArray) in tilesArray.enumerated() {
            print("Row: \(row)")
            // Note: In Sprite Kit (0,0) is at the bottom of the screen,
            // so we need to read this file upside down.
            let tileRow = NumRows - row - 1
            
            // Loop through the columns in the current r
            for (column, value) in rowArray.enumerated() {
                print("Value: \(value) ")
                
                // If the value is 1, create a tile object.
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                    print("created full tile")
                }
            }
    }
    }
    
    // MARK: Level Setup
    
    // Fills up the level with new Cookie objects

    func shuffle() -> Set<Block> {
        return createInitialBlocks()
    }
    
    private func createInitialBlocks() -> Set<Block> {
        var set = Set<Block>()
        
        // 1
        for row in 0..<NumRows{
            for column in 0..<NumColumns{
                
                // new line
                if tiles[column, row] != nil{
                    // 2
                    let blockType = BlockType.random()
                    
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
    
    // MARK: Query the level
    
    // Returns the block at the specified column and row, or nil when there is none.
    func blockAt(column: Int, row: Int) -> Block? {
        assert(column>=0 && column<NumColumns)
        assert(row>=0 && row<NumRows)
        return blocks[column, row]
    }
    
    // Determines whether there's a tile at the specified column and row.
    func tileAt(column: Int, row: Int) -> Tile? {
        assert(column>=0 && column<NumColumns)
        assert(row>=0 && row<NumRows)
        return tiles[column, row]
    }
    
    
/* Load the named file into a Dictionary using the loadJSONFromBundle(filename:) helper function that you just added. Note that this function may return nil -- it returns an optional -- and here you use a guard to handle this situation.
 
     The dictionary has an array named "tiles". This array contains one element for each row of the level. Each of those row elements is itself an array containing the columns for that row. The type of tilesArray is therefore array-of-array-of-Int, or [[Int]].
 
     Step through the rows using built-in enumerated() function, which is useful because it also returns the current row number.
 
     In Sprite Kit (0, 0) is at the bottom of the screen, so you have to reverse the order of the rows here. The first row you read from the JSON corresponds to the last row of the 2D grid.
 
     Step through the columns in the current row. Every time it finds a 1, it creates a Tile object and places it into the tiles array.*/
    
    
    

}
