//
//  TotalledApp.swift
//  Shared
//
//  Created by Michael Duncan on 01/04/2022.
//

import SwiftUI
import CoreData

@main
struct TotalledApp: App {
    @StateObject private var modelView = ModelView.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ModelView.load { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let players):
                            modelView.players = players
                    }
                }
            }
        }
    }
}

class ModelView: ObservableObject {
    @Published var dest = 0
    public static var shared = ModelView()
    @Published var player1: String = "Player 1"
    @Published var player2: String = "Player 2"
    @Published var players: [Player] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("totalled.data")
    }
    
    static func load(completion: @escaping (Result<[Player], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let players = try JSONDecoder().decode([Player].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(players))
                }
            } catch {
                
            }
        }
    }
    
    static func save(players: [Player], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(players)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(players.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func setDestination(id: Int) {
        self.dest = id
    }
    
    func addPlayer(player: Player){
        self.players.append(player)
        ModelView.save(players: self.players) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func getPlayer(name: String) -> Player {
        return self.players.first(where: {$0.name == name})!
    }
    
    func editPlayer(oldName: String, newName: String) {
        var player = self.getPlayer(name: oldName)
        player.name = newName
        ModelView.save(players: self.players) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func deletePlayer(player: String){
        self.players.remove(at: players.firstIndex {$0.name == player}!)
        ModelView.save(players: self.players) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func getPlayerStrings() -> [String] {
        var ps: [String] = []
        for i in self.players {
            ps.append(i.name)
        }
        
        return ps
    }
    
    func createMatch(player1: String, player2: String) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func settleFrame(winner: String, winnerBallsRemaining: Int, loserBallsRemaining: Int, isAdded: Bool) {
        let winningPlayer = self.players.first(where: {$0.name == winner})!
        var losingPlayer: Player
        if winner == self.player1 {
            losingPlayer = self.players.first(where: {$0.name == self.player2})!
        } else {
            losingPlayer = self.players.first(where: {$0.name == self.player1})!
        }
        if isAdded == true {
            winningPlayer.framesPlayed += 1
            losingPlayer.framesPlayed += 1
            winningPlayer.framesWon += 1
            if winnerBallsRemaining != 0 {
                winningPlayer.ballsPotted += (7 - winnerBallsRemaining)
            } else {
                winningPlayer.ballsPotted += 8
            }
            losingPlayer.ballsPotted += (7 - loserBallsRemaining)
        } else if isAdded == false {
            winningPlayer.framesPlayed -= 1
            losingPlayer.framesPlayed -= 1
            winningPlayer.framesWon -= 1
            if winnerBallsRemaining != 0 {
                winningPlayer.ballsPotted -= (7 - winnerBallsRemaining)
            } else {
                winningPlayer.ballsPotted -= 8
            }
            losingPlayer.ballsPotted -= (7 - loserBallsRemaining)
        }
        winningPlayer.stats()
        losingPlayer.stats()
        ModelView.save(players: self.players) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func eraseStats(){
        for i in getPlayerStrings() {
            var player = self.getPlayer(name: i)
            player.framesPlayed = 0
            player.framesWon = 0
            player.ballsPotted = 0
        }
        ModelView.save(players: self.players) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func eraseData(){
        self.players = []
        ModelView.save(players: self.players) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
}

