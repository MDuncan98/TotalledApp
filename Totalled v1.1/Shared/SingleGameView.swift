//
//  SingleGameView.swift
//  Totalled
//
//  Created by Michael Duncan on 01/04/2022.
//

import SwiftUI

struct SingleGameView: View {
    @State var player1: String = ""
    @State var player2: String = ""
    @State var invalidGame = false
    @ObservedObject private var modelView = ModelView.shared
    
    func gameIsValid() -> Bool {
        var isValid = false
        if !player1.isEmpty && !player2.isEmpty {
            if player1 != player2 {
                if modelView.getPlayerStrings().contains(player1) && modelView.getPlayerStrings().contains(player2) {
                    isValid = true
                }
            }
        }
        return isValid
    }
    
    var body: some View {
        VStack {
            TopBar(viewTitle: "1 vs 1")
            Spacer()
                .frame(height: 100)
            PlayerPicker(player1: $player1, player2: $player2, type: 1, textColor: Color("Menu Red"))
            Spacer()
                .frame(height: 50)
            Text("VS")
                .font(.system(size: 50))
                .foregroundColor(Color.white)
            Spacer()
                .frame(height: 50)
            PlayerPicker(player1: $player1, player2: $player2, type: 2, textColor: Color("Menu Yellow"))
            Spacer()
            Button("Start"){
                if gameIsValid() == true {
                    modelView.createMatch(player1: player1, player2: player2)
                    modelView.setDestination(id: 5)
                } else { invalidGame = true }
            }
            .frame(width: 175, height: 40, alignment: .center)
            .font(.title)
            .padding(10)
            .addBorder(Color.white, width: 3, cornerRadius: 10)
            .foregroundColor(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
            )
            .alert("Invalid Players", isPresented: $invalidGame) {
                Button("OK", role: .cancel) {  }
                } message: {
                    Text("Please select two different players. If you haven't set any up yet, press the + icon to get started.")
                }
            Spacer()
        }
        .modifier(BackgroundColorStyle())
    }
}

struct SingleGameView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGameView()
    }
}


struct TopBar: View {
    @ObservedObject private var modelView = ModelView.shared
    @State var viewTitle: String
    @State var createPlayer = false
    @State var createPlayerSuccess = false
    @State var playerName: String = ""
    var body: some View {
        VStack {
            HStack {
                ZStack{
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .background(Circle().fill(Color(UIColor.systemGray6)))
                        .frame(width:45, height: 45)
                    Button {
                        modelView.setDestination(id: 0)
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                    .foregroundColor(.blue)
                    .font(.system(size:25))
                    .frame(alignment: .center)
                }
                .frame(width:45, height:45)
                Spacer()
                Text(viewTitle)
                    .font(.system(size: 35))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 225, height: 50)
                    .addBorder(Color.gray, width: 1, cornerRadius: 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                    )
                Spacer()
                ZStack{
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .background(Circle().fill(Color(UIColor.systemGray6)))
                        .frame(width:45, height: 45)
                    Button {
                        createPlayer = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                    .foregroundColor(.blue)
                    .font(.system(size:25))
                    .popover(isPresented: $createPlayer) {
                        VStack {
                            VStack(spacing: 0){
                                HStack{
                                    Button("Cancel") {
                                        playerName = ""
                                        createPlayer = false
                                    }
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.blue)
                                    .padding(.leading, 10)
                                    .frame(width: 100, alignment: .center)
                                    Spacer()
                                    Text("Add Player")
                                        .font(.title)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                    Button("Create") {
                                        guard !playerName.isEmpty else { return }
                                        modelView.addPlayer(player: Player(name: playerName))
                                        print(modelView.players)
                                        playerName = ""
                                        createPlayerSuccess = true
                                    }
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.blue)
                                    .padding(.trailing, 10)
                                    .frame(width: 100, alignment: .center)
                                    .alert("Player Created", isPresented: $createPlayerSuccess) {
                                        Button("OK", role: .cancel) { createPlayer = false }
                                    } message: {
                                        Text("Your new player was created successfully.")
                                    }
                                }
                                .padding(.vertical, 20)
                                .background(Color("Cloth Green Reversed"))
                                Divider().background(Color.white)
                            }
                            Spacer()
                            TextField("Enter your name:", text: $playerName)
                                .frame(width: 300, height: 50, alignment: .center)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Spacer()
                            Text("")
                            Spacer()
                            Text("")
                            Spacer()
                        }
                        .modifier(BackgroundColorStyle())
                    }
                }
            }
        .padding(.horizontal, 20.0)
        .frame(maxWidth: .infinity, maxHeight: 75)
        }
        Divider().background(Color.white)
    }
}

struct PlayerPicker: View {
    @Binding var player1: String
    @Binding var player2: String
    @State var player: String = ""
    @State var type: Int
    var textColor: Color
    @ObservedObject private var modelView = ModelView.shared
    
    var body: some View {
        HStack() {
            if type == 2 {
                VStack {
                    Divider()
                        .frame(height: 1.5)
                        .background(Color.white)
                }
            }
            VStack {
                    Picker(selection: $player, label: Text("Select Player")) {
                        if modelView.players.count == 0 {
                            Text("No Players")
                                .foregroundColor(textColor)
                                .font(.system(size: 25))
                        }
                        else {
                            Text("Select a player:").tag("")
                                .foregroundColor(textColor)
                                .font(.system(size: 25))
                            ForEach(modelView.getPlayerStrings(), id: \.self) {
                                Text($0)
                                    .foregroundColor(textColor)
                                    .font(.system(size: 25))
                            }
                        }
                    }
                        .pickerStyle(WheelPickerStyle())
                        .onChange(of: player, perform: { newValue in
                            if type == 1 {
                                player1 = newValue
                            } else if type == 2 {
                                player2 = newValue
                            }})
                        .frame(width: 200, height: 110)
                        .addBorder(Color.white, width: 2, cornerRadius: 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                        )
                        .cornerRadius(12)
                        .clipped()
            }
            .padding(10)
            if type == 1 {
                VStack {
                    Divider()
                        .frame(height: 1.5)
                        .background(Color.white)
                }
            }
        }
    }
}

