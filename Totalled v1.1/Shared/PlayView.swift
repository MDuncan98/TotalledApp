//
//  PlayView.swift
//  Totalled
//
//  Created by Michael Duncan on 12/04/2022.
//

import SwiftUI

struct PlayView: View {
    @ObservedObject private var modelView = ModelView.shared
    @Binding var player1: String
    @Binding var player2: String
    @State var score1: Int = 0
    @State var score2: Int = 0
    @State var timerString = ""
    @State var timeRemaining = 0
    @State var disabledTextField = false
    @State var coinPopover = false
    @State var resetAlert = false
    @State var shotAlert = false
    @State var headsOrTails: Int = 0
    @State var resultText = ""
    @State var resultDesc = ""
    @State var playerSelect = ""
    @State var imageString = "Red Coin"
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var frameStack: [Frame] = []
    
    var body: some View {
        VStack {
            GameBar(viewTitle: "1 vs 1")
            dividedTitle(header: "Frames Won:")
            ZStack {
                HStack(spacing: 0) {
                    Color("Pool Red")
                    Color("Pool Yellow")
                  }
                  .edgesIgnoringSafeArea(.all)
                HStack {
                    Spacer()
                    playerScore(playerText: player1, opponent: player2, score: $score1, frameStack: $frameStack)
                    Spacer()
                    playerScore(playerText: player2, opponent: player1, score: $score2, frameStack: $frameStack)
                    Spacer()
                }
            }
            .frame(height: 200)
            dividedTitle(header: "Options:")
            Spacer()
            HStack{
                VStack {
                    Divider().background(Color.white)
                }
                Button("Coin Flip") {
                    resultText = ""
                    resultDesc = ""
                    if Int.random(in: 0...1) == 0 {
                        playerSelect = player1
                    } else {
                        playerSelect = player2
                    }
                    coinPopover = true
                }
                    .frame(width: 175, height: 40, alignment: .center)
                    .addBorder(Color.gray, width: 1, cornerRadius: 10)
                    .font(.headline)
                    .foregroundColor(Color("Menu Red"))
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                    )
                    .padding(.trailing, 20)
                    .popover(isPresented: $coinPopover) {
                        VStack(spacing: 0) {
                            HStack {
                                Button("Cancel") {
                                    coinPopover = false
                                }
                                    .foregroundColor(Color.blue)
                                    .font(.system(size: 20))
                                    .frame(width: 75)
                                    .padding(.leading, 20)
                                Spacer()
                                Text("Coin Flip")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                    .frame(alignment: .center)
                                Spacer()
                                HStack {
                                    
                                }
                                .frame(width: 75)
                                .padding(.trailing, 20)
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                            .background(Color("Cloth Green Reversed"))
                            Divider().background(Color.white)
                            Spacer()
                            Text("\(playerSelect):")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                            Spacer()
                            Image(imageString)
                                .resizable()
                                .frame(width: 200, height: 200)
                            Spacer()
                            HStack{
                                Spacer()
                                Button("Heads") {
                                    headsOrTails = Int.random(in: 0...1)
                                    if headsOrTails == 0 {
                                        imageString = "Yellow Coin"
                                        resultText = "Correct!"
                                        resultDesc = "You win the toss."
                                    } else {
                                        imageString = "Red Coin"
                                        resultText = "Incorrect."
                                        resultDesc = "Opponent wins the toss."
                                    }
                                }
                                .frame(width: 100, height: 50)
                                .padding(20)
                                .font(.title)
                                .foregroundColor(Color("Menu Yellow"))
                                .addBorder(Color.gray, width: 1, cornerRadius: 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                                )
                                Spacer()
                                Button("Tails") {
                                    headsOrTails = Int.random(in: 0...1)
                                    if headsOrTails == 1 {
                                        imageString = "Red Coin"
                                        resultText = "Correct!"
                                        resultDesc = "You win the toss."
                                    } else {
                                        imageString = "Yellow Coin"
                                        resultText = "Incorrect."
                                        resultDesc = "Opponent wins the toss."
                                    }
                                }
                                .frame(width: 100, height: 50)
                                .font(.title)
                                .foregroundColor(Color("Menu Red"))
                                .padding(20)
                                .addBorder(Color.gray, width: 1, cornerRadius: 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                                )
                                Spacer()
                            }
                            Group {
                                Spacer()
                                Text(resultText)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .frame(height: 50)
                                Spacer()
                                Text(resultDesc)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(height: 25)
                                Spacer()
                            }
                        }
                        .modifier(BackgroundColorStyle())
                    }
            }
            Spacer()
            Group {
                HStack{
                    VStack {
                        Divider().background(Color.white)
                    }
                    HStack{
                        TextField("0", text: $timerString)
                            .disabled(disabledTextField)
                            .frame(width: 60, height: 40, alignment: .center)
                            .keyboardType(.decimalPad)
                            //.padding(10)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            //.addBorder(Color.gray, width: 1, cornerRadius: 10)
                            .onReceive(timer) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                    timerString = String(timeRemaining)
                                } else {
                                    disabledTextField = false
                                    if timerString == "0" {
                                        shotAlert = true
                                    }
                                }
                            }
                            .alert("Timer has ended", isPresented: $shotAlert, actions: {
                                Button("Close", role: .cancel) { timerString = "" }
                            })
                        Button("Shot Clock") {
                            if !timerString.isEmpty {
                                disabledTextField = true
                                timeRemaining = Int(timerString) ?? 0
                            }
                        }
                            .frame(width: 100, height: 40, alignment: .center)
                            .font(.headline)
                            .foregroundColor(Color("Menu Yellow"))
                            .addBorder(Color.gray, width: 1, cornerRadius: 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                            )
                        //Text("\(timeRemaining)")
                    }
                    .frame(width: 175, height: 40, alignment: .center)
                    .padding(.trailing, 20)
                }
                Spacer()
                HStack{
                    VStack {
                        Divider().background(Color.white)
                    }
                    Link("Rules", destination: URL(string: "http://www.euro8ball.com/other/Rules_Jan_2020.pdf")!)
                        .frame(width: 175, height: 40, alignment: .center)
                        .addBorder(Color.gray, width: 1, cornerRadius: 10)
                        .font(.headline)
                        .foregroundColor(Color("Menu Red"))
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                        )
                        .padding(.trailing, 20)
                }
                Spacer()
                HStack{
                    VStack {
                        Divider().background(Color.white)
                    }
                    Button("Reset Scores") {
                        resetAlert = true
                    }
                        .frame(width: 175, height: 40, alignment: .center)
                        .font(.headline)
                        .foregroundColor(Color("Menu Yellow"))
                        .addBorder(Color.gray, width: 1, cornerRadius: 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
                        )
                        .padding(.trailing, 20)
                        .alert("Reset Scores?", isPresented: $resetAlert, actions: {
                            Button("Cancel", role: .cancel) { }
                            Button("Reset", role: .destructive) {
                                while frameStack.count > 0 {
                                    let selectedFrame = frameStack.last
                                    modelView.settleFrame(winner: selectedFrame!.winner, winnerBallsRemaining: (8 - selectedFrame!.winnerBallsPotted), loserBallsRemaining: (8 - selectedFrame!.loserBallsPotted), isAdded: false)
                                    frameStack.removeLast()
                                }
                                (score1, score2) = (0,0)
                            }
                        }, message: {
                            Text("Reset all scores in this game?")
                        })
                }
                Spacer()
            }
        }
        .modifier(BackgroundColorStyle())
    }
}

struct playerScore: View {
    @State var playerText: String
    @State var opponent: String
    @Binding var score: Int
    @State var addAlert = false
    @State var removeAlert = false
    @State var winFrame = false
    @State var ballsLeft: Int = 0
    @State var oppBallsLeft: Int = 0
    @State var selectedTab: Int = 0
    @Binding var frameStack: [Frame]
    @StateObject private var modelView = ModelView.shared
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text(playerText)
                    .font(.headline)
                Spacer()
            }
            HStack {
                Button {
                    if score != 0 {
                        removeAlert = true
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20))
                }
                .alert("Remove Frame?", isPresented: $removeAlert, actions: {
                    Button("Remove", role: .destructive) {
                        if !playerText.contains("Player") {
                            let selectedFrame = frameStack.last(where: {$0.winner == playerText})
                            var wbr = 0
                            if selectedFrame!.winnerBallsPotted != 8 {
                                wbr = Int(7 - selectedFrame!.winnerBallsPotted)
                            } else {
                                wbr = Int(8 - selectedFrame!.winnerBallsPotted)
                            }
                            modelView.settleFrame(winner: playerText, winnerBallsRemaining: wbr, loserBallsRemaining: (7 - selectedFrame!.loserBallsPotted), isAdded: false)
                            frameStack.remove(at: frameStack.lastIndex {$0.winner == playerText}!)
                        }
                        score -= 1
                    }
                    Button("Cancel", role: .cancel) { }
                }, message: {
                    Text("Do you want to remove the last winning frame for \(playerText)? This data will be deleted permanently!")
                })
                Text(String(score))
                    .font(.title)
                    .frame(width: 75, height: 75, alignment: .center)
                    .addBorder(Color.gray, width: 1, cornerRadius: 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(UIColor.systemGray6))
                    )
                Button {
                    addAlert = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                }
                .font(.system(size:15))
                .alert(isPresented: $addAlert) {
                    Alert(
                        title: Text("Confirm Win"),
                        message: Text("Did \(playerText) win that frame?"),
                        primaryButton: .destructive(
                            Text("No"),
                            action: { }
                        ),
                        secondaryButton: .default(
                            Text("Yes"),
                            action: { winFrame = true }
                        )
                    )
                }
                .popover(isPresented: $winFrame) {
                    VStack {
                        VStack(spacing: 0) {
                            HStack{
                                Button("Cancel"){
                                    winFrame = false
                                }
                                .font(.system(size: 20))
                                .foregroundColor(Color.blue)
                                .padding(.leading, 10)
                                .frame(width: 100, alignment: .center)
                                Spacer()
                                Text("Result")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                Spacer()
                                Button("Confirm") {
                                    if !playerText.contains("Player") {
                                        if selectedTab == 0 {
                                            frameStack.append(Frame(winner: playerText, wbp: 8, lbp: (7 - ballsLeft)))
                                            modelView.settleFrame(winner: playerText, winnerBallsRemaining: 0, loserBallsRemaining: ballsLeft, isAdded: true)
                                        } else if selectedTab == 1 {
                                            frameStack.append(Frame(winner: playerText, wbp: (7 - ballsLeft), lbp: (7 - oppBallsLeft)))
                                            modelView.settleFrame(winner: playerText, winnerBallsRemaining: (ballsLeft), loserBallsRemaining: oppBallsLeft, isAdded: true)
                                        }
                                    }
                                    winFrame = false
                                    score += 1
                                }
                                .font(.system(size: 20))
                                .foregroundColor(Color.blue)
                                .padding(.trailing, 10)
                                .frame(width: 100, alignment: .center)
                            }
                            .padding(.vertical, 20)
                            .background(Color("Cloth Green Reversed"))
                            Divider().background(Color.white)
                        }
                        Text("How was the frame decided?")
                            .font(.title)
                            .foregroundColor(Color.white)
                        Picker("Decided", selection: $selectedTab) {
                            Text("7 Balls + Black").tag(0)
                            Text("Illegal Black from Opponent").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color("Cloth Green Reversed"))
                        switch(selectedTab) {
                        case 0: StandardWinView(playerText: $playerText, opponent: $opponent, ballsLeft: $ballsLeft)
                        case 1: IllegalWinView(playerText: $playerText, opponent: $opponent, playerBallsLeft: $ballsLeft, oppBallsLeft: $oppBallsLeft)
                        default: StandardWinView(playerText: $playerText, opponent: $opponent, ballsLeft: $ballsLeft)
                        }
                    }
                    .modifier(BackgroundColorStyle())
                }
            }
        }
    }
}

struct StandardWinView: View {
    @Binding var playerText: String
    @Binding var opponent: String
    @Binding var ballsLeft: Int
    var body: some View {
        Spacer()
        Text("\(playerText), how many balls did **\(opponent)** have left on the table?")
            .font(.title)
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
        Spacer()
        Picker("Balls Left:", selection: $ballsLeft) {
            ForEach(0..<8) {
                Text("\($0)")
                    
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color("Cloth Green Reversed"))
        Spacer()
    }
}

struct IllegalWinView: View {
    @Binding var playerText: String
    @Binding var opponent: String
    @Binding var playerBallsLeft: Int
    @Binding var oppBallsLeft: Int
    var body: some View {
        VStack{
            Spacer()
            Text("**NOT** including the black ball:")
                .font(.title)
                .foregroundColor(Color.white)
            Spacer()
            Text("How many balls did \(playerText) have left on the table?")
                .foregroundColor(Color.white)
            Picker("Balls Left:", selection: $playerBallsLeft) {
                ForEach(0..<8) {
                    Text("\($0)")
                        
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color("Cloth Green Reversed"))
            Spacer()
            Text("How many balls did \(opponent) have left on the table?")
                .foregroundColor(Color.white)
            Picker("Balls Left:", selection: $oppBallsLeft) {
                ForEach(0..<8) {
                    Text("\($0)")
                        
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color("Cloth Green Reversed"))
            Spacer()
        }
        .modifier(BackgroundColorStyle())
    }
}

struct dividedTitle: View {
    @State var header: String
    var body: some View {
        HStack {
            VStack {
                Divider().background(Color.white)
            }
            Text(header)
                .font(.headline)
                .foregroundColor(Color.white)
            VStack {
                Divider().background(Color.white)
            }
        }
    }
}

struct GameBar: View {
    @ObservedObject private var modelView = ModelView.shared
    @State var viewTitle: String
    @State var createPlayer = false
    @State var createPlayerSuccess = false
    @State var playerName: String = ""
    @State var backAlert = false
    @State var homeAlert = false
    var body: some View {
        VStack{
            HStack {
                ZStack{
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .background(Circle().fill(Color(UIColor.systemGray6)))
                        .frame(width:45, height: 45)
                    Button {
                        backAlert = true
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                    .foregroundColor(.blue)
                    .font(.system(size:25))
                    .frame(alignment: .center)
                }
                .alert(isPresented: $backAlert) {
                Alert(
                    title: Text("Exit Game?"),
                    message: Text("Are you sure you want to exit the current game? All unsaved data will be lost!"),
                    primaryButton: .default(
                        Text("Stay"),
                        action: {  }
                    ),
                    secondaryButton: .destructive(
                        Text("Exit"),
                        action: {
                            modelView.player1 = "Player 1"
                            modelView.player2 = "Player 2"
                            modelView.setDestination(id: 1) }
                    )
                )
                }
                Spacer()
                Text(viewTitle)
                    .font(.system(size: 35))
                    .foregroundColor(Color.white)
                    .frame(width: 225, height: 50)
                    .multilineTextAlignment(.center)
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
                        homeAlert = true
                    } label: {
                        Image(systemName: "house")
                    }
                    .foregroundColor(.blue)
                    .font(.system(size:25))
                }
                .alert(isPresented: $homeAlert) {
                    Alert(
                        title: Text("Exit Game?"),
                        message: Text("Are you sure you want to exit the current game? All unsaved data will be lost!"),
                        primaryButton: .default(
                            Text("Stay"),
                            action: {  }
                        ),
                        secondaryButton: .destructive(
                            Text("Exit"),
                            action: {
                                modelView.player1 = "Player 1"
                                modelView.player2 = "Player 2"
                                modelView.setDestination(id: 0) }
                        )
                    )
                }
            }
            .padding(.horizontal, 20.0)
            .frame(maxWidth: .infinity, maxHeight: 75)
        }
    }
}

extension View {
     public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
         let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
         return clipShape(roundedRect)
              .overlay(roundedRect.strokeBorder(content, lineWidth: width))
     }
 }

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(player1: .constant("Player"), player2: .constant(""))
    }
}
