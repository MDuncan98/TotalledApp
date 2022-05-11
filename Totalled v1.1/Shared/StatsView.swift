//
//  StatsView.swift
//  Totalled
//
//  Created by Michael Duncan on 01/04/2022.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject private var modelView = ModelView.shared
    @State var player = ""
    @State var deleteStatsAlert = false
    @State var deleteDataAlert = false
    var percent: CGFloat = 0.7
    var statTitles: [String] = [
        "Frames Played:",
        "Frames Won:",
        "Win/Loss Ratio:",
        "Balls Potted:",
        "Balls/Frame Average:"
    ]
    @State var statValues: [String] = []
    var body: some View {
        VStack {
            TopBar(viewTitle: "Player Stats")
            Divider()
            Spacer()
            StatsPicker(player: $player)
            Spacer()
            HStack {
                VStack {
                    Divider().background(Color.white)
                }
                ViewStatsButton(player: $player, statValues: $statValues)
                VStack {
                    Divider().background(Color.white)
                }
            }
            GeometryReader { geo in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        ForEach(statTitles, id: \.self) { str in
                            Text(str)
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                    }
                    .frame(width: (geo.size.width / 2) - 20)
                    Divider().background(Color.white)
                    VStack {
                        Spacer()
                        ForEach(statValues, id: \.self) { str in
                            Text(str)
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                    }
                    .frame(width: (geo.size.width / 2) - 20)
                    Spacer()
                }
            }
            .frame(height: 250)
            Divider().background(Color.white)
            HStack {
                Spacer()
                Button("Delete Existing Stats"){
                    deleteStatsAlert = true
                }
                .frame(width: 170, height: 50)
                .addBorder(Color.white, width: 3, cornerRadius: 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                )
                .foregroundColor(Color("Menu Red"))
                .alert("Delete All Stats?", isPresented: $deleteStatsAlert, actions: {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        modelView.eraseStats()
                        statValues = []
                    }
                }, message: {
                    Text("Are you sure you wish to delete all stats? This cannot be undone! \nOnly stats will be deleted; profiles will still remain.")
                })
                Spacer()
                Button("Delete All Data") {
                    deleteDataAlert = true
                }
                .frame(width: 170, height: 50)
                .addBorder(Color.white, width: 3, cornerRadius: 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                )
                .foregroundColor(Color("Menu Red"))
                .alert("Delete All Data?", isPresented: $deleteDataAlert, actions: {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        modelView.eraseData()
                        player = ""
                        statValues = []
                    }
                }, message: {
                    Text("Are you sure you wish to delete all stats and profiles? This cannot be undone!")
                })
                Spacer()
            }
        }
        .modifier(BackgroundColorStyle())
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

struct StatsPicker: View {
    @Binding var player: String
    @ObservedObject private var modelView = ModelView.shared
    var body: some View {
        Picker("Player 1:", selection: $player, content: {
            Text("Select a player:").tag("")
                .foregroundColor(Color.white)
                .font(.system(size: 25))
            ForEach(modelView.getPlayerStrings(), id: \.self) {
                Text($0)
                    .foregroundColor(Color.white)
                    .font(.system(size: 25))
            }
        })
            .pickerStyle(WheelPickerStyle())
            .addBorder(Color.white, width: 2, cornerRadius: 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
            )
            .frame(width: 150, height:100)
    }
}

struct ViewStatsButton: View {
    @Binding var player: String
    @Binding var statValues: [String]
    @ObservedObject private var modelView = ModelView.shared
    var body: some View {
        Button("View Stats") {
            if !player.isEmpty {
                let player = modelView.getPlayer(name: player)
                var winLossRatio: Float = 0
                var ballsPerGame: Float = 0
                if player.framesPlayed != 0 {
                    if player.framesWon == player.framesPlayed {
                        winLossRatio = Float(player.framesPlayed)
                    } else {
                        winLossRatio = (Float(player.framesWon) / Float(player.framesPlayed - player.framesWon))
                    }
                    winLossRatio = round(100 * winLossRatio) / 100
                }
                if player.ballsPotted != 0 {
                    ballsPerGame = (Float(player.ballsPotted) / Float(player.framesPlayed))
                    ballsPerGame = round(100 * ballsPerGame) / 100
                }
                statValues = [
                    String(player.framesPlayed),
                    String(player.framesWon),
                    String(winLossRatio),
                    String(player.ballsPotted),
                    String(ballsPerGame)
                ]
            }
        }
        .frame(width: 200, height: 60)
        .font(.title)
        .addBorder(Color.white, width: 3, cornerRadius: 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
        )
        .foregroundColor(Color("Menu Yellow"))
    }
}
