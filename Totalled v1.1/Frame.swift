//
//  Frame.swift
//  Totalled (iOS)
//
//  Created by Michael Duncan on 26/04/2022.
//

import Foundation

class Frame: Identifiable, Codable {
    let winner: String
    let loserBallsPotted: Int
    let winnerBallsPotted: Int
    
    init(winner: String, wbp: Int, lbp: Int) {
        self.winner = winner
        self.winnerBallsPotted = wbp
        self.loserBallsPotted = lbp
    }
}
