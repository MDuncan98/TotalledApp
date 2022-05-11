//
//  Player.swift
//  Totalled (iOS)
//
//  Created by Michael Duncan on 08/04/2022.
//

import Foundation

class Player: Identifiable, Codable {
    var name: String
    var framesPlayed: Int
    var framesWon: Int
    var ballsPotted: Int
    
    init(name: String){
        self.name = name
        (self.framesPlayed, self.framesWon, self.ballsPotted) = (0, 0, 0)
    }
    
    init(name: String, framesPlayed: Int, framesWon: Int, ballsPotted: Int) {
        self.name = name
        self.framesPlayed = framesPlayed
        self.framesWon = framesWon
        self.ballsPotted = ballsPotted
    }
    
    func stats() {
        print("\(self.name):\nFrames played: \(self.framesPlayed)\nFrames Won: \(self.framesWon)\nBalls Potted: \(self.ballsPotted)")
    }
}
