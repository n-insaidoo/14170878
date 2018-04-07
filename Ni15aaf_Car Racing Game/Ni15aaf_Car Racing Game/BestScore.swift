//
//  BestScore.swift
//  Ni15aaf_Car Racing Game
//
//  Created by ni15aaf on 07/04/2018.
//  Copyright © 2018 ni15aaf. All rights reserved.
//

import Foundation
import UIKit
import os.log

struct PropertyKey{
    static let score = "score"
}


class BestScore: NSObject, NSCoding{
    
    var score: Int!
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("best_score")
    
    init(score: Int){
        self.score = score
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(score, forKey: PropertyKey.score)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
         guard let score = aDecoder.decodeObject(forKey: PropertyKey.score) as? Int else {
         os_log("Unable to decode the score for a BestScore object.", log: OSLog.default, type: .debug)
         return nil
         }
        
        //let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        
        // Must call designated initializer.
        self.init(score: score)
    }
}
