//
//  ContentView.swift
//  Shared
//
//  Created by Michael Duncan on 01/04/2022.
//

import SwiftUI
import CoreData


struct BackgroundColorStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .background(Color("Cloth Green"))
    }
}

struct ContentView: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
        //UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    @ObservedObject private var modelView = ModelView.shared
    var body: some View {
        switch modelView.dest {
        case 1:
            SingleGameView()
        case 2:
            PlayView(player1: $modelView.player1, player2: $modelView.player2)
        case 3:
            ProfilesView() {
                ModelView.save(players: modelView.players) {result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        case 4:
            StatsView()
        case 5:
            PlayView(player1: $modelView.player1, player2: $modelView.player2)
        default:
            MenuView()
        }
    }
}

struct MenuView: View {
    var body: some View {
        VStack {
            HStack{
                Image("Totalled Banner")
                    .resizable()
                    .frame(width: 330, height: 121)
            }
            .frame(maxWidth: .infinity, maxHeight: 150)
            Spacer()
            MenuButton(buttonText: "Quick Play", bodyText: "Get into a game without profiles.", bID: 2, outlineColor: Color("Menu Red"))
            Spacer()
            MenuButton(buttonText: "1 vs 1", bodyText: "Track your games versus an opponent", bID: 1, outlineColor: Color("Menu Yellow"))
            Spacer()
            MenuButton(buttonText: "Player Profiles", bodyText: "Create, view, add and remove player profiles.", bID: 3, outlineColor: Color("Menu Red"))
            Spacer()
            MenuButton(buttonText: "Player Stats", bodyText: "View detailed statistics about each player.", bID: 4, outlineColor: Color("Menu Yellow"))
            Spacer()
        }
        .modifier(BackgroundColorStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MenuButton: View {
    @State var buttonText: String
    @State var bodyText: String
    @ObservedObject private var modelView = ModelView.shared
    var bID: Int
    var outlineColor: Color

    var body: some View {
        HStack{
            VStack{
                Divider()
                    .frame(height: 1.5)
                    .background(Color.white)
            }
            Button(buttonText){
                modelView.setDestination(id: bID)
            }
            .frame(width: 175, height: 40, alignment: .center)
            .padding(10)
            .addBorder(Color.white, width: 3, cornerRadius: 10)
            .foregroundColor(outlineColor)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("Cloth Green Reversed"))
            )
            .font(.title)
            .padding(.trailing, 20)
            }
        HStack {
            Spacer()
            Text(bodyText)
                .multilineTextAlignment(.center)
            .frame(width: 200)
            .foregroundColor(Color.white)
        }
        .padding(.trailing, 20)
            
    }
}
