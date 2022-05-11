//
//  ProfilesView.swift
//  Totalled
//
//  Created by Michael Duncan on 01/04/2022.
//

import SwiftUI
import UIKit

struct ProfilesView: View {
    @ObservedObject private var modelView = ModelView.shared
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    @State var deleteAlert = false
    @State var editPlayer = false
    @State var editPlayerSuccess = false
    @State var playerToDelete = ""
    @State var playerToEdit = ""
    @State private var playerString = ""
    var body: some View {
        VStack{
            TopBar(viewTitle: "Player Profiles")
            ScrollView {
                ForEach(modelView.players) { plyr in
                    HStack {
                        Text(plyr.name)
                            .font(.title)
                            .foregroundColor(Color.white)
                            .padding(.leading, 25)
                            .frame(width: 150, alignment: .leading)
                        Spacer()
                        Button(action: {
                            playerToEdit = plyr.name
                            editPlayer = true
                        }) {
                            Text("Edit")
                                .font(.title)
                                .foregroundColor(Color.blue)
                        }
                        Spacer()
                        Button {
                            playerToDelete = plyr.name
                            deleteAlert = true
                        } label: {
                            Text("Delete")
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        .padding(.trailing, 25)
                        .alert("Delete Player?", isPresented: $deleteAlert, actions: {
                            Button("Delete", role: .destructive) {
                                modelView.deletePlayer(player: playerToDelete)
                                playerToDelete = ""
                            }
                            Button("Cancel", role: .cancel) { }
                        }, message: {
                            Text("Are you really sure you want to delete this player? This cannot be undone, and all of their data will be lost forever!")
                        })
                    }
                    .frame(height: 50)
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive { saveAction() }
                }
            }
            .modifier(BackgroundColorStyle())
            .popover(isPresented: $editPlayer) {
                VStack {
                    VStack(spacing: 0) {
                        HStack{
                            Button("Cancel") {
                                playerString = ""
                                editPlayer = false
                            }
                            .font(.system(size: 20))
                            .foregroundColor(Color.blue)
                            .padding(.leading, 10)
                            .frame(width: 100, alignment: .center)
                            Spacer()
                            Text("Edit Player")
                                .font(.title)
                                .foregroundColor(Color.white)
                            Spacer()
                            Button("Confirm") {
                                guard !playerString.isEmpty else { return }
                                modelView.editPlayer(oldName: playerToEdit, newName: playerString)
                                print(modelView.getPlayer(name: playerString))
                                playerString = ""
                                editPlayerSuccess = true
                            }
                            .font(.system(size: 20))
                            .foregroundColor(Color.blue)
                            .padding(.leading, 10)
                            .frame(width: 100, alignment: .center)
                            .alert("Player Created", isPresented: $editPlayerSuccess) {
                                Button("OK", role: .cancel) { editPlayer = false }
                            } message: {
                                Text("Name was changed successfully.")
                            }
                        }
                        .padding(.vertical, 20)
                        .background(Color("Cloth Green Reversed"))
                        Divider().background(Color.white)
                    }
                    Spacer()
                    TextField("Enter new name:", text: $playerString)
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
        .modifier(BackgroundColorStyle())
    }
}

/*struct ProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesView()
    }
}*/
